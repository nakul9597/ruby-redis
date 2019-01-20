require_relative '../../framework/error_framework'

class SortedSetErrorController
  
  def self.zadd(args)
    RedisError.argument_check(args,2)
  end

  def self.zcard(args)
    status = RedisError.argument_check(args,0)
    status
  end

  def self.zcount(args)
    status = RedisError.argument_check(args,2)
    status = RedisError.integer_check(args[1],args[2]) if status.code == 200
    status
  end

  def self.zrank(args)
    status = RedisError.argument_check(args,1)
    status = RedisError.sorted_set_data_check(args[0]) if status.code == 200
    status
  end

  def self.zrange(args)
    status = RedisError.argument_check(args,2,3)
    status = RedisError.sorted_set_data_check(args[0]) if status.code == 200
    status = RedisError.integer_check(args[1],args[2]) if status.code == 200
    return Status.new(402) unless ((args[3] == "withscore") or (args[3] == nil))
    status
  end

end