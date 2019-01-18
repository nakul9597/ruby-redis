class RedisError

	def self.argument_error(args,idx)
		(0..idx).each {|i| return 400 if args[i] == nil}
		return 200
	end

end