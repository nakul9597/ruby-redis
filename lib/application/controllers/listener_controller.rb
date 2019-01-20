require_relative '../model/string_model'
require_relative 'string_error_controller'
require_relative '../model/sorted_set_model'
require_relative 'sorted_set_error_controller'
require_relative 'functionality_controller'
require_relative '../model/db_model'

module Listener
  
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
    stringdata = StringModel.new
    case command
    when "set"
      status = StringErrorController.set(args)
      return status if status.code != 200
      stringdata.set(*args)
    when "get"
      status = StringErrorController.get(args)
      return status if status.code != 200
      stringdata.get(*args)
    when "setbit"
      status = StringErrorController.setbit(args)
      return status if status.code != 200
      stringdata.setbit(*args)
    when "getbit"
      status = StringErrorController.getbit(args)
      return status if status.code != 200
      stringdata.getbit(*args)
    when "setex"
      status = StringErrorController.set_ttl(args)
      return status if status.code != 200
      stringdata.setex(*args)
    when "setmx"
      status = StringErrorController.set_ttl(args)
      return status if status.code != 200
      stringdata.setmx(*args)
    when "setnx"
      status = StringErrorController.set(args)
      return status if status.code != 200
      stringdata.setnx(*args)
    when "setxx"
      status = StringErrorController.set(args)
      return status if status.code != 200
      stringdata.setxx(*args)
    else
      Status.new(404)
    end
  end

  def self.sortedset_route(command,args)
    sortedsetdata = SortedSetModel.new
    case command
    when "zadd"
      status = SortedSetErrorController.zadd(args)
      return status if status.code != 200
      sortedsetdata.zadd(*args)
    when "zcard"
      status = SortedSetErrorController.zcard(args)
      return status if status.code != 200
      sortedsetdata.zcard(*args)
    when "zcount"
      status = SortedSetErrorController.zcount(args)
      return status if status.code != 200
      sortedsetdata.zcount(*args)
    when "zrange"
      status = SortedSetErrorController.zrange(args)
      return status if status.code != 200
      sortedsetdata.zrange(*args)
    when "zrank"
      status = SortedSetErrorController.zrank(args)
      return status if status.code != 200
      sortedsetdata.zrank(*args)
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
