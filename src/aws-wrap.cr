require "option_parser"
require "json"

require "./lib/errmsg"
require "./lib/utils"
require "./lib/awscli"
require "./lib/outputs"

module Aws::Wrap
  extend self

  Utils.die "Usage: aws-wrap ..." unless ARGV.size > 0
  Awscli.exec ARGV unless (ARGV.join(" ") =~ /cloudformation deploy/)

  stack_name = nil

  cmdline_args = ARGV.dup
  OptionParser.parse(cmdline_args) do |parser|
    parser.on("--stack-name=NAME", "stack name") { |name| stack_name = name }
    parser.invalid_option { |_| }
    parser.missing_option { |_| Utils.die Errmsg::NO_STACK }
  end

  Utils.die Errmsg::NO_STACK if stack_name.nil?

  deploy_cmd = ARGV
  imported_outputs = [] of String
  imported_outputs = Outputs.from_pipe if Utils.got_pipe? STDIN

  deploy_cmd = deploy_cmd + imported_outputs

  Utils.dputs "deployment cmd : '#{deploy_cmd.join(" ")}'"
  _, error = Awscli.run deploy_cmd
  Utils.die "Deployment of the stack #{stack_name} has failed:\n#{error}" unless error.nil?

  imported_outputs = imported_outputs + Outputs.from_stack(stack_name.not_nil!)

  puts imported_outputs.join("\n") if Utils.got_pipe? STDOUT
end
