require_relative 'error_controller'

class StringErrorController

	def self.set(args)
		RedisError.argument_check(args,1)
	end

	def self.get(args)
		RedisError.argument_check(args,0)
	end

	def self.setbit(args)
		status = RedisError.argument_check(args,2)
		status = RedisError.integer_check(args[1]) if status.code == 200
		status = RedisError.binary_check(args[2]) if status.code == 200
		status
	end

	def self.getbit(args)
		status = RedisError.argument_check(args,1)
		status = RedisError.integer_check(args[1]) if status.code == 200
		status
	end

	def self.set_ttl(args)
		status = RedisError.argument_check(args,2)
		status = RedisError.integer_check(args[1]) if status.code == 200
		status
	end

end