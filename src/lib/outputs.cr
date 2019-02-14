require "./awscli"

module Outputs

  extend self

  def from_pipe : Array(String)
    Utils.dputs "reading from pipe"
    imports = [] of String
    STDIN.each_line(chomp: true) do |l|
      Utils.dputs "PIPE IN: #{l}"
      next unless l =~ /=/
      imports << l
    end
    Utils.dputs "imports collected: #{imports}"

    imports
  end

  def from_stack(stack_name : String) : Array(String)
    cmd = %w(cloudformation describe-stacks --output json --stack-name)
    cmd << stack_name

    output, error = Awscli.run cmd
    Utils.die "Failed requesting stack parameters for #{stack_name}: #{error}" unless error.nil?

    stack_info = JSON.parse(output)["Stacks"].as_a.first
    return [] of String unless stack_info.as_h.has_key? "Outputs"

    stack_info["Outputs"]
      .as_a
      .reduce([] of String) do |acc, kv|
        k = kv["OutputKey"]
        v = kv["OutputValue"]
        acc << "#{k}=#{v}"

        acc
    end

  end

end
