require_relative 'generic_commands_model'

class StringModel

  def set(key,value,*args)
    GenericCommandsModel.persist(key) if !!$ttl_thread[key]

    option = args[0]
    return(set_options(option.downcase,args,key,value)) if !!option

    $data[key] = value
    return Status.new(200)
  end

  def get(key)
    $data[key] ? $data[key] : Status.new(202)
  end

  def setex(key,expiretime,value)
    set(key,value)
    GenericCommandsModel.expire(key,expiretime.to_i,"ex")
  end

  def setpx(key,expiretime,value)
    set(key,value)
    GenericCommandsModel.expire(key,expiretime.to_i,"mx")
  end

  def setbit(key,offset,bitvalue)
    orig_bit_val = ""
    binary = $data[key]? $data[key].unpack("B*")[0] : ""
    (0...((offset.to_i/8+1)*8)).each do |i|
    	binary[i] = "0" if binary[i] == nil
    	(orig_bit_val = binary[i]; binary[i] = bitvalue) if i == offset.to_i
    end
    $data[key] = [binary].pack("B*")
    return orig_bit_val.to_i
  end

  def setnx(key,value)
    return 0 if $data.keys.include?(key)
    set(key,value)
    return 1
  end

  def setxx(key,value)
    return 0 unless $data.keys.include?(key)
    set(key,value)
    return 1
  end

  def getbit(key,offset)
    $data[key]? $data[key].unpack("B*")[0][offset.to_i].to_i : 0
  end

  private
  def set_options(option,args,key,value)
    if(option == "ex")
      if (args[2] == "NX")
        status = self.setnx(key,value)
        return Status.new(202) if status == 0
      elsif (args[2] == "XX")
        status = self.setxx(key,value)
        return Status.new(202) if status == 0
      else
        status = self.set(key,value)
      end
      return GenericCommandsModel.expire(key,args[1].to_i,"ex")
    elsif(option == "px")
      if (args[2] == "NX")
        status = self.setnx(key,value)
        return Status.new(202) if status == 0
      elsif (args[2] == "XX")
        status = self.setxx(key,value)
        return Status.new(202) if status == 0
      else
        status = self.set(key,value)
      end
      return GenericCommandsModel.expire(key,args[1].to_i,"px")
    elsif option == "nx"
      status  = self.setnx(key,value)
      status == 1 ? Status.new(200) : Status.new(202)
    elsif option == "xx"
      status =  self.setxx(key,value)
      status == 1 ? Status.new(200) : Status.new(202)
    end
  end

end