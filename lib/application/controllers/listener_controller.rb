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
      status = StringErrorController.set_ttl(args)
      return status if status.code != 200
      StringController.setex(*args)
    when "setmx"
      status = StringErrorController.set_ttl(args)
      return status if status.code != 200
      StringController.setmx(*args)
    when "setnx"
      status = StringErrorController.set(args)
      return status if status.code != 200
      StringController.setnx(*args)
    when "setxx"
      status = StringErrorController.set(args)
      return status if status.code != 200
      StringController.setxx(*args)
    else
      Status.new(404)
    end
  end

  def self.sortedset_route(command,args)
    case command
    when "zadd"
      status = SortedSetErrorController.zadd(args)
      return status if status.code != 200
      SortedSetController.zadd(*args)
    when "zcard"
      status = SortedSetErrorController.zcard(args)
      return status if status.code != 200
      SortedSetController.zcard(*args)
    when "zcount"
      status = SortedSetErrorController.zcount(args)
      return status if status.code != 200
      SortedSetController.zcount(*args)
    when "zrange"
      status = SortedSetErrorController.zrange(args)
      return status if status.code != 200
      SortedSetController.zrange(*args)
    when "zrank"
      status = SortedSetErrorController.zrank(args)
      return status if status.code != 200
      SortedSetController.zrank(*args)
    else
      Status.new(404)
    end
  end

  def self.funtionality_route(command,args)
    case command
    when "save"
      DB_Model.db_save
      Status.new(600)
    when "ttl"
      FunctionalityController.ttl(*args)
    when "persist"
      FunctionalityController.persist(*args)
    when "quit"
      DB_Model.db_save
      Status.new(999)
    else
      Status.new(404)
    end
  end

end
