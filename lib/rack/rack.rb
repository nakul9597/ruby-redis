require_relative '../framework/router_framework'
require_relative '../framework/app_runner'
require_relative '../status'
require 'socket'

class MyRack

  def self.start
    server = TCPServer.open(3000)
    loop do
      @socket = server.accept
      loop do
        env = self.request_process
        (@socket.close; break) if self.socket_close?(env)
        self.response(env);
        display_response(env["command"])
      end
    end

  end

  def self.request_process

    if request = @socket.gets
      command,args = request.split(" ",2).map(&:strip)
      new_env_render(command,args)
    end

  end

  def self.new_env_render(command,args)
    {
      "command" => command.downcase,
      "args" => args.split(" ").map(&:strip)
    }
  end

  def self.response(env)
    @response_val = App.call(env)
  end

  def self.display_response(command)
    case @response_val.class.to_s
    when "Status"
      @socket.puts(Status.code_value(command)[@response_val.code])
    when "Integer"
      @socket.puts("(integer)"+@response_val.to_s)
    else
      @socket.puts(@response_val)
    end
    @socket.puts($data)
  end

  def self.socket_close?(response)
    response["command"] == "quit"
  end

end
