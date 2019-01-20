require_relative '../framework/router_framework'
require_relative '../application/controllers/router_controller'
require_relative '../status'
require 'socket'

class Rack

  def initialize
    @server = TCPServer.open(15000)
  end

  def start
    loop do
      @socket = @server.accept
      @socket.puts("\nWelcome to exo-redis\nData loaded for disk..\nType a command to start\n\n")
      loop do
        begin
          @socket.write("C: ")
          env = request_process
          response(env);
          display_response(env["command"])
          (@socket.close; break) if socket_close?(env)
        rescue StandardException => e
          print(e)
        end
      end
    end
  end

  private
  def request_process

    if request = @socket.gets
      command,args = request.split(" ",2).map(&:strip)
      new_env_render(command,args)
    end

  end

  def new_env_render(command,args)
    {
      "command" => command.downcase,
      "args" => args.split(" ").map(&:strip)
    }
  end

  def response(env)
    command_type = RouterFramework.find(env)
    @response_val = RouterController.new.route_control(command_type,env["command"],env["args"])
  end

  def display_response(command)
    case @response_val.class.to_s
    when "Status"
      @socket.puts(Status.code_value(command)[@response_val.code])
    when "Integer"
      @socket.puts("(integer) "+@response_val.to_s)
    when "String"
      @socket.puts("\"#{@response_val}\"")
    else
      @socket.puts(@response_val)
    end
  end

  def socket_close?(response)
    response["command"] == "quit"
  end

end
