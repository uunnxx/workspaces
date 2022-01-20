class Foo
  def singleton_method_removed(name)
    puts "singleton method \"#{name}\" was removed"
  end
end

obj = Foo.new
def obj.foo
end

def obj.bar
end

class << obj
  remove_method :foo
  remove_method :bar
end
