require "rltk"

require "rbsh/printable"
require "rbsh/syntax"
require "rbsh/semantic"


module RBSH
  private

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