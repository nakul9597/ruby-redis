class Status

  attr_accessor :code
  
  def initialize(code=nil	)
    @code = code
  end
  
  def self.code_value(command,args)
    {
      200 => "+OK\r\n",
      202 => "$-1\r\n",
      420 => "-WRONGTYPE Operation against a key holding the wrong kind of value\r\n",
      430 => "-ERR min or max is not a float\r\n",
      440 => "-ERR value is not an integer or out of range\r\n",
      600 => "-ERR unknown command `#{command}`, with args beginning with:#{(" "+args.collect{ |x| "`#{x}`"}.join(", ")+",") unless args.empty?}\r\n",
      700 => "-ERR bit offset is not an integer or out of range\r\n",
      702 => "-ERR bit is not an integer or out of range\r\n",
      999 => "*0\r\n",
      1001 => "-File not found\r\n"
    }
  end

end