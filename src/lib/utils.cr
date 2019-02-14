module Utils

  extend self

  def die(msg : String)
    STDERR.puts "*** #{msg}"
    exit 1
  end

  def is_debug_on?
    ENV.has_key?("DEBUG") && ! ENV["DEBUG"].empty?
  end

  def dputs(msg : String)
    STDERR.puts "[#{Process.pid}] DEBUG // #{msg}" if is_debug_on?
  end

  def got_pipe?(fd)
    ! fd.tty?
  end

end
