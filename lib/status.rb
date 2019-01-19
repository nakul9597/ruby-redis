class Status
	attr_accessor :code
	def initialize(code=nil	)
		@code = code
	end
	def self.code_value(command)
    {
      200 => "Ok",
      202 => "(nil)",
      204 => "(empty sorted set)",
      400 => "(error) ERR wrong number of arguments for '#{command}' command",
      402 => "(error) ERR syntax error",
      404 => "CommandError: '#{command}' is not a valid command",
      420 => "(error) ERR value is not an integer or out of range",
      500 => "(error) ERR bitvalue must be 0/1"
    }
  end

end