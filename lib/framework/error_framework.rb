class RedisError

  def self.argument_check(args,idx,optional=nil)
    (0..idx).each {|i| return Status.new(400) if args[i] == nil}
    idx = optional if optional != nil
    return Status.new(400) if args.length > idx+1
    return Status.new(200)
  end

  def self.integer_check(*values)
    values.each {|value| return Status.new(420) if !value.match(/\A\d+\z/) }
    return Status.new(200)
  end

  def self.binary_check(value)
    return Status.new(500) if !value.match(/\A[01]\z/)
    return Status.new(200)
  end

  def self.string_data_check(key)
    if $data[key]
      return Status.new(200) if $data[key].class == String
      return Status.new(210)
    else
      return Status.new(202)
    end
  end

  def self.sorted_set_data_check(key)
    if $data[key]
      return Status.new(200) if $data[key].class == Array
      return Status.new(210)
    else
      return Status.new(204)
    end
  end
end