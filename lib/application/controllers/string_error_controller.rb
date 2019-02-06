require_relative '../../framework/error_framework'

class StringErrorController

  def self.get(args)
    status = ErrorFramework.string_data_check(args[0])
    status
  end

  def self.setbit(args)
    status = ErrorFramework.string_data_check(args[0])
    status = ErrorFramework.bit_check(args[1]) if status.code == 200
    status = ErrorFramework.binary_check(args[2]) if status.code == 200
    status
  end

  def self.getbit(args)
    status = ErrorFramework.string_data_check(args[0])
    status = ErrorFramework.bit_check(args[1]) if status.code == 200
    status
  end

  def self.set_ttl(args)
    status = ErrorFramework.integer_check(args[1]) if status.code == 200
    status
  end

end
