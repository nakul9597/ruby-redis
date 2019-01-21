class RouterFramework

  def self.find(env)
    return "string" if !!env['command'].match(/\A[sg]et(.)*/)
    return "sorted_set" if !!env['command'].match(/\Az(.){3,}/)
    return "others"
  end

end
