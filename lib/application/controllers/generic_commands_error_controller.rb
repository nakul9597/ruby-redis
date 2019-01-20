require_relative '../../framework/error_framework'

class GenericCommandsErrorController
  
  def self.ttl(args)
    RedisError.argument_check(args,0)
  end

  def self.persist(args)
    RedisError.argument_check(args,0)
  end

end