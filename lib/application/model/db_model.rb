require_relative '../../framework/model'

class DB_Model
	private
  def self.db_save
    Database.write
  end

  def self.get_db_data
  	$ttl_thread = Hash.new
  	$data = Hash.new
    Database.read
  end

end
