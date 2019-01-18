Dir["/home/nakulwarrier/workspace/ruby/ruby_redis/lib/application/controllers/*.rb"].each {|file| require_relative file }
require_relative '../model/db_model'

class Listener

  def self.route_control(command_type,command,args)
    case command_type
    when "string"
      self.string_route(command, args)
    when "sorted_set"
      self.sortedset_route(command, args)
    else 
      self.funtionality_route(command, args)
    end
  end

  def self.string_route(command,args)
    case command
    when "set"
      status = StringErrorController.set(args)
      return status if status.code != 200
      StringController.set(*args)
    when "get"
      status = StringErrorController.get(args)
      return status if status.code != 200
      StringController.get(*args)
    when "setbit"
      status = StringErrorController.setbit(args)
      return status if status.code != 200
      StringController.setbit(*args)
    when "getbit"
      status = StringErrorController.getbit(args)
      return status if status.code != 200
      StringController.getbit(*args)
    when "setex"
      StringController.setex(*args)
    when "setmx"
      StringController.setmx(*args)
    when "setnx"
      StringController.setnx(*args)
    when "setxx"
      StringController.setxx(*args)
    else
      404
    end
  end

  def self.sortedset_route(command,args)
    case command
    when "zadd"
      SortedSetController.zadd(*args)
    when "zcard"
      SortedSetController.zcard(*args)
    when "zcount"
      SortedSetController.zcount(*args)
    when "zrange"
      SortedSetController.zrange(*args)
    when "zrank"
      SortedSetController.zrank(*args)
    else
      404
    end
  end

  def self.funtionality_route(command,args)
    case command
    when "save"
      DB_Model.db_save
      ["wabalaba",444]
    when "ttl"
      FunctionalityController.ttl(*args)
    when "persist"
      FunctionalityController.persist(*args)
    else
      404
    end
  end

end
