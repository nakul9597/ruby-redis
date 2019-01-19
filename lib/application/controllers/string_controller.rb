require_relative 'functionality_controller'
require_relative '../../status'

class StringController

	def self.set(key,value)
		FunctionalityController.persist(key) if !!$ttl_thread[key]
		begin
			$data[key] = value
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
		binary = $data[key]? $data[key].unpack("B*")[0] : ""
		(0...((offset.to_i/8+1)*8)).each do |i|
			binary[i] = "0" if binary[i] == nil
			orig_bit_val = binary[i]; binary[i] = bitvalue if i == offset.to_i
		end
		$data[key] = [binary].pack("B*")
		return orig_bit_val.to_i
	end

	def self.setnx(key,value)
		return false if $data.keys.include?(key)
		self.set([key,value])
	end

	def self.setxx(key,value)
		return false unless $data.keys.include?(key)
		self.set([key,value])
	end

	def self.getbit(key,offset)
		$data[key]? $data[key].unpack("B*")[0][offset.to_i] : false
	end

end