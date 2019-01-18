class Status
	attr_accessor :code
	def initialize(code=nil	)
		@code = code
	end
	def self.code_value(command)
    {
      200 => "Ok",
      202 => "(nil)",
      400 => "(error) ERR wrong number of arguments for '#{command}' command",
      402 => "(error) ERR syntax error",
      404 => "CommandError: '#{command}' is not a valid command",
      420 => "(error) ERR value is not an integer or out of range"
    }
  end

end