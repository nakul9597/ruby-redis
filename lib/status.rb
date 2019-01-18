class Status
	attr_accessor :code
	def initialize(code=nil	)
		@code = code
	end
	def self.code_value(command)
    {
      200 => "Ok",
      202 => "(nil)",
      400 => "(error) ERR wrong number of arguments for #{command} command \n If you want to know the syntax for all command type help",
      404 => "CommandError: #{command} is not a valid command"
    }
  end

end