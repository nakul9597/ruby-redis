require_relative '../../framework/error_framework'

module SortedSetErrorController
  
  def self.zadd(args)
    ErrorFramework.argument_check(args,2)
  end

  def self.zcard(args)
    status = ErrorFramework.argument_check(args,0)
    status
  end

  def self.zcount(args)
    status = ErrorFramework.argument_check(args,2)
    status = ErrorFramework.integer_check(args[1],args[2]) if status.code == 200
    status
  end

  def self.zrank(args)
    status = ErrorFramework.argument_check(args,1)
    status = ErrorFramework.sorted_set_data_check(args[0]) if status.code == 200
    status
  end

  def self.zrange(args)
    status = ErrorFramework.argument_check(args,2,3)
    status = ErrorFramework.sorted_set_data_check(args[0]) if status.code == 200
    status = ErrorFramework.integer_check(args[1],args[2]) if status.code == 200
    return Status.new(402) unless ((args[3] == "withscore") or (args[3] == nil))
    status
  end

end