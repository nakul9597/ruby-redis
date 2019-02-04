class Status

  attr_accessor :code
  
  def initialize(code=nil	)
    @code = code
  end
  
  def self.code_value(first_byte,command)
    {
      200 => "+OK\r\n",
      202 => "$-1\r\n",
      420 => "-(WRONGTYPE Operation against a key holding the wrong kind of value)\r\n",
      999 => "#{first_byte}0\r\n"
    }
  end

end