
module RBSH
  class Object < ::Object
    # We call this when ruby's normal lookup fails.
    # This method searches for an executable with the
    # same name as the symbol.
    def method_missing(symbol, *args, &block)
      unless which(symbol.to_s)
        return super(symbol, *args, &block)
      end

      # check if its a command
      # if not, balk
      # if so
      #   return an object that wraps a command, OR
      #   pass the argument to the existing command



    end
  end

  # Cross-platform way of finding an executable in the $PATH.
  # Stolen from http://mislav.net/ via stackoverflow
  #
  #   which('ruby') #=> /usr/bin/ruby
  def which(cmd)
    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
      exts.each { |ext|
        exe = File.join(path, "#{cmd}#{ext}")
        return exe if File.executable?(exe) && !File.directory?(exe)
      }
    end
    return nil
  end


end