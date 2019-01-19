require_relative 'functionality_controller'
require_relative '../../status'

class StringController
	
	def self.set(key,value,*args)
		FunctionalityController.persist(key) if !!$ttl_thread[key]
		option = args[0]
		if(option == "ex")
			if (args[2] == "nx")
				setnx(key,value)
			elsif (args[2] == "xx")
				setxx(key,value)
			else
				set(key,value)
			end
			return FunctionalityController.expire(key,args[1].to_i,"ex")
		elsif(option == "mx")
			if (args[2] == "nx")
				setnx(key,value)
			elsif (args[2] == "xx")
				setxx(key,value)
			else
				set(key,value)
			end
			return FunctionalityController.expire(key,args[1].to_i,"mx")
		elsif option == "nx"
			return setnx(key,value)
		elsif option == "xx"
			return setxx(key,value)
		end

		begin
			$data[key] = format_value(value)
		rescue StandardError => e
			return e.to_s
		end
		return Status.new(200)
	end

	def self.get(key)
		$data[key] ? $data[key] : Status.new(202)
	end

	def self.setex(key,expiretime,value)
		self.set(key,value)
		FunctionalityController.expire(key,expiretime.to_i,"ex")
	end

	def self.setmx(key,expiretime,value)
		self.set(key,value)
		FunctionalityController.expire(key,expiretime.to_i,"mx")
	end

	def self.setbit(key,offset,bitvalue)
		orig_bit_val = ""
		binary = $data[key]? $data[key].unpack("B*")[0] : ""
		(0...((offset.to_i/8+1)*8)).each do |i|
			binary[i] = "0" if binary[i] == nil
			(orig_bit_val = binary[i]; binary[i] = bitvalue) if i == offset.to_i
		end
		$data[key] = [binary].pack("B*")
		return orig_bit_val.to_i
	end

	def self.setnx(key,value)
		return Status.new(202) if $data.keys.include?(key)
		self.set(key,value)
	end

	def self.setxx(key,value)
		return Status.new(202) unless $data.keys.include?(key)
		self.set(key,value)
	end

	def self.getbit(key,offset)
		$data[key]? $data[key].unpack("B*")[0][offset.to_i].to_i : Status.new(202)
	end

	def self.format_value(value)
		return value[1..-2] if !!value.match(/\A\"(.)+\"\z/)
		value
	end

end