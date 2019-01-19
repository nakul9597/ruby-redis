require_relative 'router_framework'
require_relative '../application/model/db_model'
require_relative '../application/controllers/listener_controller'
require_relative '../rack/rack'

class App
	private
  def self.run
    DB_Model.get_db_data
    MyRack.start
  end

  def self.call(env)
    command_type = Router.find(env)
    Listener.route_control(command_type,env["command"],env["args"])
  end

end
