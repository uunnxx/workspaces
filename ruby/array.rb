# https://www.reddit.com/r/ruby/comments/q0lrmf/add_to_specific_elements_of_an_array_the_ruby_way/

def array_element_update(array)
  array_new = []
  array.each_with_index do |element, index|
    if index >= 1 && index <= 3
      element = element + 3
    end
    array_new.append(element)
  end
  array_new
end

array = [1, 2, 3, 4, 5]

puts array_element_update(array)


def array_element_update(array)
  array.map.with_index do |element, index|
    (1..3).include?(index) ? element + 3 : element
  end
end


[1, 2, 3, 4, 5].map.with_index do |number, index|
  index >= 1 && index <= 3 ? number += 3 : number
end


def do_stuff(array)
  array.map.with_index do |n, i|
    if (1..3).cover? i
      n += 3
    else
      n
    end
  end
end
