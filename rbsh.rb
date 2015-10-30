#1/usr/bin/env ruby
require 'shellwords'

BUILTINS = {
  "cd" => lambda { |dir| Dir.chdir(dir) },
  "exit" => lambda { |code = 0| exit(code.to_i) },
  "source" => nil,
  "alias" => nil,
  "disown" => nil,
  "echo" => nil,
  "exec" => nil,
  "history" => nil,
  "help" => nil,
  "kill" => nil,
  "logout" => nil,
  "pwd" => nil,
  "umask" => nil,
  'set' => lambda { |args|
    key, value = args.split('=')
    ENV[key] = value
  }
}
loop do
  $stdout.print '-> '
  line = $stdin.gets.strip
  command, *arguments = Shellwords.shellsplit(line)

  if BUILTINS[command]
    BUILTINS[command].call(*arguments)
  else
    pid = fork {
      exec line
    }

    Process.wait pid
  end
end

# PATH

#This works
eval("@x = 5")
puts @x