require_relative '../../status'
class RedisError

	def self.argument_check(args,idx)
		(0..idx).each {|i| return Status.new(400) if args[i] == nil}
		return Status.new(400) if args.length > idx+1
		return Status.new(200)
	end

	def self.integer_check(value)
		return Status.new(420) if !value.match(/\A\d+\z/)
		return Status.new(200)
	end

end