class RedisError

	def self.status_code(env)
		{
			400 => "(error) ERR wrong number of arguments for #{env['command']} command \n If you want to know the syntax for all command type help",
		}
	end

	def self.argument_error(args,idx)
		(0..idx).each {|i| return 400 if args[i] == nil}
		return 200
	end

end