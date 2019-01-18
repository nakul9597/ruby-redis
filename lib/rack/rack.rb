require_relative '../framework/router_framework'
require_relative '../framework/app_runner'
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
        display_response
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
    @response_val,@status = App.call(env)
  end

  def self.display_response
    @socket.puts([@response_val,$data])
  end

  def self.socket_close?(response)
    response["command"] == "quit"
  end
end
