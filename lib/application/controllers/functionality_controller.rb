class FunctionalityController
	
	def self.expire(key,expire_value,expire_time)
		$ttl_thread[key] = Thread.new{
			(expire_value+1).times do
				expire_value -= 1
				sleep(1) if expire_time == "ex"
				sleep(0.001) if expire_time == "mx"
				Thread.current[:output] = expire_value
			end
			$data.delete(key)
			$ttl_thread[key].terminate
		}
		return (true)
	end

end