Dir["/home/nakulwarrier/workspace/ruby/ruby_redis/lib/application/controllers/*.rb"].each {|file| require_relative file }
require_relative '../model/db_model'

class Listener

  def self.route_control(command_type,command,args,app)
    case command_type
    when "string"
      app.response = self.string_route(command, args)
    when "sorted_set"
      app.response = self.sortedset_route(command, args)
    else 
      app.response = self.funtionality_route(command, args)
    end
  end

  def self.string_route(command,args)
    case command
    when "set"
      status_code = StringErrorController.set(args)
      return status_code if status_code != 200
      StringController.set(args)
    when "get"
      status_code = StringErrorController.get(args)
      return status_code if status_code != 200
      StringController.get(args)
    when "setbit"
      status_code = StringErrorController.setbit(args)
      return status_code if status_code != 200
      StringController.setbit(args)
    when "getbit"
      status_code = StringErrorController.getbit(args)
      return status_code if status_code != 200
      StringController.getbit(args)
    when "setex"
      StringController.setex(args)
    else
      ["invalid",404]
    end
  end

  def self.sortedset_route(command,args)
    case command
    when "zadd"
      ["hello",100]
    else
      ["invalid",404]
    end
  end

  def self.funtionality_route(command,args)
    case command
    when "save"
      DB_Model.db_save
      ["wabalaba",444]
    else
      ["invalid",404]
    end
  end

end
