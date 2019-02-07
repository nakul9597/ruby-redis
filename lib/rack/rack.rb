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
      begin
        loop do
          begin
            env = request_process
            response(env)
            display_response(env)
            (@socket.close; break) if socket_close?(env)
          rescue StandardError => e
            @socket.puts(e)
          end
        end
      rescue SystemExit => e
        @socket.close
        exit
      end
    end
  end

  private
  def request_process
    final_request = []
    request = @socket.gets()
    @request_type, number_of_requests = request_helper(request)
    number_of_requests.to_i.times do
      request = @socket.gets()
      request_type, request_length = request_helper(request)
      request = @socket.gets()
      final_request << request[0...request_length.to_i]
    end
    new_env_render(final_request[0],final_request[1..-1])
  end

  def new_env_render(command,args)
    {
      "command" => command.downcase,
      "args" => args
    }
  end

  def response(env)
    command_type = RouterFramework.find(env)
    @response_val = RouterController.new.route_control(command_type,env["command"],env["args"])
  end

  def display_response(env)
    case @response_val.class.to_s
    when "Status"
      @socket.puts(Status.code_value(env["command"],env["args"])[@response_val.code])
    when "Integer"
      @socket.puts(":#{@response_val}\r\n")
    when "String"
      @socket.puts("$#{@response_val.size}\r\n#{@response_val}\r\n")
    else
      @socket.puts(@response_val[0])
    end
  end

  def request_helper(request)
    request = request.strip
    return([request[0],request[1..-1]])
  end

  def socket_close?(response)
    response["command"] == "quit"
  end

end
