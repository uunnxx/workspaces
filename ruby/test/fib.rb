def fib(n)
  new, old = 1, 0
  n.times { new, old = new + old, new }
  old
end

# times = ARGV[0].to_i
times = 100

times.times.each do |i|
  fib(i)
end

puts "Hi"