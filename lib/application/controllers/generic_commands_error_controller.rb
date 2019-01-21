require_relative '../../framework/error_framework'

module GenericCommandsErrorController
  
  def self.ttl(args)
    ErrorFramework.argument_check(args,0)
  end

  def self.persist(args)
    ErrorFramework.argument_check(args,0)
  end

end