def flatten(array, result = [])
  (array || []).each do |elem|
    if elem.kind_of?(Array)
      flatten(elem, result)
    elsif elem.kind_of?(Fixnum)
      result << elem
    else
      raise "Invalid element #{elem.inspect}. Only Fixnum acceptable."
    end
  end

  result
end
