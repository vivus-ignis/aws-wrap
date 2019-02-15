module Utils

  extend self

  def die(msg : String)
    STDERR.puts "*** #{msg}"
    exit 1
  end

  def is_debug_on?
    ENV.has_key?("DEBUG") && ENV["DEBUG"] == "true"
  end

  def dputs(msg : String)
    STDERR.puts "[#{Process.pid}] DEBUG // #{msg}" if is_debug_on?
  end

  def got_pipe?(filedes : IO::FileDescriptor)
    Utils.dputs("#{filedes.fd}")
    dev_file = case filedes.fd
               when 0
                 "/dev/stdin"
               when 1
                 "/dev/stdout"
               when 2
                 "/dev/stderr"
               else
                 return ! filedes.tty? # fallback method to test
               end

    File.info(dev_file).type.pipe?
  end

end
