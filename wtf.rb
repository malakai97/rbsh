def method_missing(method, *args, &block)
  puts "#{method} #{args}"
  super
end

eval("git checkout -c --no-ff origin -- herpderp")