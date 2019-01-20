require_relative 'router_framework'
require_relative '../application/model/db_model'
require_relative '../application/controllers/listener_controller'
require_relative '../rack/rack'

module Server
	
  def self.run
    puts "Starting Exo-Redis..\nLoading data from disk...\nWaiting for clients.."
    trap("INT") 
    {
      puts "\n\nSaving data to disk\nShutting down."
      DB_Model.db_save
      exit
    }
    DB_Model.get_db_data
    Rack.start
  end

end
