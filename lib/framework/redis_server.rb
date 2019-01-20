require_relative 'router_framework'
require_relative '../application/model/db_model'
require_relative '../rack/rack'

class Server

  def initialize
    puts "Starting Exo-Redis..\nLoading data from disk...\nWaiting for clients.."
    handle_ctr_c
  end

  def load_data
    DB_Model.get_db_data
  end

  def run
    Rack.new.start
  end

  private
  def handle_ctr_c
    trap("INT") {puts "\n\nSaving data to disk\nShutting down.";DB_Model.db_save;exit}
  end

end
