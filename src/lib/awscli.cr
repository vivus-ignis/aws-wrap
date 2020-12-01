require "./utils"

module Awscli

  extend self

  def exec(cmd : Array(String))
    command = "aws"
    args = cmd

    Process.exec(command, args)
  end

  def run(cmd : Array(String)) : {String, String | Nil}
    command = "aws"
    args = Process.parse_arguments(cmd.join(' '))

    output = IO::Memory.new
    error_output = IO::Memory.new

    Utils.dputs "args: #{args}"

    ret = Process.run(command, args,
                      shell: false,
                      output: output,
                      error: error_output)

    Utils.dputs "retcode #{ret.exit_status} returned for command '#{command} #{args.join(" ")}'"
    Utils.dputs "OUTPUT was:\n#{output}"
    Utils.dputs "ERROR output was:\n#{error_output}"

    ret.exit_status == 0 ? {output.to_s, nil} : {output.to_s, error_output.to_s}
  end

end
