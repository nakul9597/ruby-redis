require_relative '../../framework/error_framework'

module StringErrorController

  def self.set(args)
    status = ErrorFramework.argument_check(args,1,4)
    status = set_options(args[2..-1]) if status.code == 200
    status
  end

  def self.get(args)
    status = ErrorFramework.argument_check(args,0)
    status = ErrorFramework.string_data_check(args[0]) if status.code == 200
    status
  end

  def self.setbit(args)
    status = ErrorFramework.argument_check(args,2)
    status = ErrorFramework.integer_check(args[1]) if status.code == 200
    status = ErrorFramework.binary_check(args[2]) if status.code == 200
    status
  end

  def self.getbit(args)
    status = ErrorFramework.argument_check(args,1)
    status = ErrorFramework.integer_check(args[1]) if status.code == 200
    status
  end

  def self.set_ttl(args)
    status = ErrorFramework.argument_check(args,2)
    status = ErrorFramework.integer_check(args[1]) if status.code == 200
    status
  end

  def self.set_options(options)
    return Status.new(200) if options.empty?
    if((options[0] == "ex" or options[0] == "mx") and options[1] != nil)
      status = ErrorFramework.integer_check(options[1])
      if status.code == 200
        if (options[2] == "xx")
          Status.new(200)
        elsif(options[2] == "nx")
          Status.new(200)
        elsif options[2] == nil
          Status.new(200)
        else
          Status.new(402)
        end
      else
        return status
      end
    elsif ((options[0] == "nx" or options[0] == "xx") and options[1] == nil)
      return Status.new(200)
    else
      return Status.new(402)
    end
  end

end