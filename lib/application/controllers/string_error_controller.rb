require_relative 'error_controller'

class StringErrorController

	def self.set(args)
		RedisError.argument_error(args,1)
	end

	def self.get(args)
		RedisError.argument_error(args,0)
	end

	def self.setbit(args)
		RedisError.argument_error(args,2)
	end

	def self.getbit(args)
		RedisError.argument_error(args,1)
	end

end