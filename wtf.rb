scope = binding
puts eval("a=1", scope)
puts eval("a", scope)
puts eval("def a; 3; end", scope)
puts eval("a", scope)
