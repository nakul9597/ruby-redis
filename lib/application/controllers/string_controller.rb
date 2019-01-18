require_relative 'functionality_controller'

class StringController

	def self.set(args)
		_key = args[0]
		_value = args[1]
		begin
			$data[_key] = _value
		rescue StandardError => e
			return e.to_s
		end
		return [200,"ok"]
	end

	def self.get(args)
		_key = args[0]
		$data[_key] ? $data[_key] : 404
	end

	def self.setex(args)
		_key,_expiretime,_value = args[0..2]
		self.set([_key,_value])
		FunctionalityController.expire(_key,_expiretime.to_i,"ex")
	end

	def self.setmx
		
	end

	def self.setbit(args)
		_key = args[0]
		_offset = args[1].to_i
		_bitvalue = args[2]
		binary = $data[_key]? $data[_key].unpack("B*")[0] : ""
		(0...((_offset/8+1)*8)).each do |i|
			binary[i] = "0" if binary[i] == nil
			binary[i] = _bitvalue if i == _offset
		end
		$data[_key] = [binary].pack("B*")
		return _bitvalue == "0"? 0 : 1
	end

	def self.getbit(args)
		_key = args[0]
		_offset = args[1].to_i
		$data[_key]? $data[_key].unpack("B*")[0][_offset] : false
	end

end