require_relative '../application/controllers/listener_controller'

class Router
	
  def self.find(env)
    return "string" if !!env['command'].match(/\A[sg]et(.)*/)
    return "sorted_set" if !!env['command'].match(/\Az(.){3,}/)
    return "others"
  end

end
