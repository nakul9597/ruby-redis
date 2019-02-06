require_relative '../../framework/error_framework'

class SortedSetErrorController
  
  def self.zadd(args)
    ErrorFramework.sorted_set_data_check(args[0])
  end

  def self.zcard(args)
    ErrorFramework.sorted_set_data_check(args[0])
  end

  def self.zcount(args)
    status = ErrorFramework.sorted_set_data_check(args[0])
    status = ErrorFramework.min_max_check(args[1],args[2]) if status.code == 200
    status
  end

  def self.zrank(args)
    ErrorFramework.sorted_set_data_check(args[0])
  end

  def self.zrange(args)
    status = ErrorFramework.sorted_set_data_check(args[0])
    status = ErrorFramework.integer_check(args[1],args[2]) if status.code == 200
    status
  end

end
