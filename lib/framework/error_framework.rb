class ErrorFramework

  def self.integer_check(*values)
    values.each {|value| return Status.new(440) if !value.match(/\A[+-]?\d+\z/) }
    return Status.new(200)
  end

  def self.min_max_check(*values)
    values.each {|value| return Status.new(430) if !value.match(/\A[+-]?\d+\z/) }
    return Status.new(200)
  end

  def self.bit_check(*values)
    values.each {|value| return Status.new(700) if !value.match(/\A[+-]?\d+\z/) }
    return Status.new(200)
  end

  def self.binary_check(value)
    return Status.new(702) if !value.match(/\A[01]\z/)
    return Status.new(200)
  end

  def self.string_data_check(key)
    if $data[key]
      return Status.new(200) if $data[key].class == String
      return Status.new(420)
    else
      return Status.new(200)
    end
  end

  def self.sorted_set_data_check(key)
    if $data[key]
      return Status.new(200) if $data[key].class == Array
      return Status.new(420)
    else
      return Status.new(200)
    end
  end
end
