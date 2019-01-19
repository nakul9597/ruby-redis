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
		return Status.new(200)
	end

	def self.ttl(key)
		return -2 unless $data.key?(key)
		return $ttl_thread[key] ? $ttl_thread[key][:output] : -1
	end

	def self.persist(key)
		if $ttl_thread[key] 
			$ttl_thread[key][:output] = -1
			$ttl_thread[key].terminate
			return Status.new(200)
		end
		return Status.new(202)
	end
end