require "socket"

class Server
	
	def self.start(host = '127.0.0.1', port = 3001)

		_server = TCPServer.open(host,port)
		loop do
			@socket = _server.accept
			@data = Hash.new
			@ttl_thread = Hash.new
			loop do
				_response = self.get_request
				self.write_response(_response);
				(@socket.close; break) if self.socket_close?(_response)
			end
		end

	end


	def self.get_request
		
		if _request = @socket.gets
			_responserequest = _request.split(" ").map{|item| item.strip }

			return {
				"command" => _responserequest[0],
				"value" => self.process_command(_responserequest)
			}

		end

	end

	def self.process_command(request)

		_command = request[0]
		request[1] and _command != "quit" ? _key = request[1] : (return self.argument_error(_command))
		case _command
		when "set"
			_value = request[2]
			self.set(_key,_value)
		when "setex"
			_expiretime = request[2]
			_value = request[3]
			self.set(_key,_value)
			self.expire(_key,_expiretime.to_i,"ex")
		when "setmx"
			_expiretime = request[2]
			_value = request[3]
			self.set(_key,_value)
			self.expire(_key,_expiretime.to_i,"mx")
		when "setnx"
			return false if @data.keys.include?(_key)
			_value = request[2]
			self.set(_key,_value)
		when "setxx"
			return false unless @data.keys.include?(_key)
			_value = request[2]
			self.set(_key,_value)
		when "setbit"
			_offset = request[2]
			_bitvalue = request[3]
			return self.bitvalue_error if _bitvalue != (0 or 1)
			self.setbit(_key,_offset.to_i,_bitvalue)
		when "get"
			self.get(_key)
		when "getbit"
			_offset = request[2]
			self.getbit(_key,_offset.to_i)
		when "ttl"
			self.ttl(_key)
		when "persist"
			self.persist(_key)
		when "zadd"
			_score = request[2]
			_value = request[3]
			self.zadd(_key,_score.to_i,_value)
		when "zcard"
			self.zcard(_key)
		when "zrank"
			_value = request[2]
			self.zrank(_key,_value)
		when "zcount"
			_min = request[2].to_i
			_max = request[3].to_i < @data[_key].size ? request[3].to_i : data[_key].size
			self.zcount(_key,_min,_max)
		when "zrange"
			_min = request[2].to_i
			_max = request[3].to_i
			self.zrange(_key,_min,_max)
		when "quit"
			self.quit
		else
			return self.command_error(_command)
		end

	end

	def self.set(key,value)
		begin
			@data[key] = value
		rescue StandardError => e
			return e.to_s
		end
		return true
	end

	def self.setbit(key,offset,bitvalue)
		binary = @data[key]? @data[key].unpack("B*")[0] : ""
		(0...((offset/8+1)*8)).each do |i|
			binary[i] = "0" if binary[i] == nil
			binary[i] = bitvalue if i == offset
		end
		@data[key] = [binary].pack("B*")
		return bitvalue == "0"? 0 : 1
	end

	def self.expire(key,expire_value,expire_time)
		@ttl_thread[key] = Thread.new{
			(expire_value+1).times do
				expire_value -= 1
				sleep(1) if expire_time == "ex"
				sleep(0.001) if expire_time == "mx"
				Thread.current[:output] = expire_value
			end
			@data.delete(key)
			@ttl_thread[key].terminate
		}
		return (true)
	end

	def self.get(key)
		return @data[key]? @data[key] : false
	end

	def self.getbit(key,offset)
		return @data[key]? @data[key].unpack("B*")[0][offset] : false
	end

	def self.ttl(key)
		return -2 unless @data.key?(key)
		return @ttl_thread[key] ? @ttl_thread[key][:output] : -1
	end

	def self.persist(key)
		if @ttl_thread[key] 
			@ttl_thread[key][:output] = -1
			@ttl_thread[key].terminate
			return true
		end
		false
	end

	def self.zadd(key,score,value)
		if @data[key] == nil
			@data[key] = [[score,value]]
			return 1
		else
			index_at = @data[key].bsearch_index {|index_score| index_score[0] >= score}
			if index_at == nil
				@data[key].push([score,value])
			else
				@data[key].insert(index_at,[score,value])
			end
		end
	end

	def self.zcard(key)
		return @data[key].size
	end

	def self.zrank(key,value)
		return @data[key].collect{|val| val[1]}.find_index(value)
	end

	def self.zcount(key,min,max)
		return @data[key].collect{|val| val[0]}.count &(min..max).to_a.method(:include?)
	end

	def self.zrange(key,min,max)
		temp = []
		@data[key].each_with_index do |val,idx|
			temp.push("#{idx+1}) #{val[1]}") if (min..max).to_a.include?(val[0])
		end
		return temp
	end

	def self.quit
		return false
	end

	def self.argument_error(command)
		"(error) ERR wrong number of arguments for #{command} command \n If you want to know the syntax for all command type help"
	end

	def self.command_error(command)
		"CommandError: #{command} is not a valid command"
	end

	def self.bitvalue_error
		"error: bitvalue must be 0 or 1"
	end

	def self.write_response(response)

		if response["value"] == true
			@socket.puts("Ok")
		elsif response["value"] == false
			@socket.puts("(nil)")
		else
			@socket.puts(response["value"])
		end

	end

	def self.socket_close?(response)
		response["command"] == "quit"
	end
end

Server::start()