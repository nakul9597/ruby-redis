require_relative '../../framework/model'

module DB_Model

  def self.db_save
    Database.write
  end

  def self.get_db_data
    $ttl_thread = Hash.new
    $data = Hash.new
    Database.read
  end

end
