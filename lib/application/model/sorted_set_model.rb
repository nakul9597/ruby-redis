class SortedSetModel

  def zadd(key,*args)
    options = ["NX","XX","INCR","CH"]
    options.each do |option|
      return zadd_options(key,args) if args.include?(option)
    end
    score, value,incr_value = args
    score = score.to_i
    if $data[key] == nil
      $data[key] = [[value,score]]
      return 1 if !incr_value
      return score.to_s
    else
      idx = $data[key].collect{|x| x[0]}.find_index(value)
      if idx != nil
        if incr_value !=nil
          incr_value = $data[key][idx][1] 
          $data[key].delete_at(idx)
          zadd(key,score+incr_value,value,0)
          return (score+incr_value).to_s
        else
          $data[key].delete_at(idx)
          zadd(key,score,value)
          return 0
        end
      end
      index_at = $data[key].bsearch_index {|index_score| index_score[1] >= score}
      if index_at == nil
        $data[key].push([value,score])
        return 1 if !incr_value
        return score.to_s
      end

      loop do 
        if $data[key][index_at] == nil
          $data[key].push([value,score])
          return 1 if !incr_value
          return score.to_s
        end
        if $data[key][index_at][1] == score 
          if $data[key][index_at][0] < value
            index_at += 1
            next
          else
            $data[key].insert(index_at,[value,score])
            return 1 if !incr_value
            return score.to_s
          end
        else
          $data[key].insert(index_at,[value,score])
          return 1 if !incr_value
          return score.to_s
        end
      end
    end
  end

  def zcard(key)
    $data[key] ? $data[key].size : 0
  end

  def zrank(key,value)
    return Status.new(202) if !$data[key]
    rank = $data[key].collect{|val| val[0]}.find_index(value)
    rank == nil ? Status.new(202) : rank
  end

  def zcount(key,min,max)
    return 0 if !$data[key]
    (count_val = $data[key].collect{|val| val[1].to_s}.count &(min..max).to_a.method(:include?))
  end

  def zrange(key,min,max,score = nil)
    return ["*0\r\n"] if !$data[key]
    temp = ""
    $data[key][min.to_i..max.to_i]. each do |node|
      temp += "$#{node[0].size}\r\n#{node[0]}\r\n"
      if score == "WITHSCORES"
        temp += "$#{node[1].to_s.size}\r\n#{node[1]}\r\n"
      end
    end
    count_val = temp.scan(/(\r)(\n)/).count
    temp = "*#{count_val/2}\r\n"+temp
    return [temp]
  end

  private
  def zadd_options(key,args)
    score = args[-2]
    value = args[-1]
    status = 0
    nx_flag = 0
    xx_flag = 0
    incr_flag = args.include?("INCR")
    if args.include?("NX")
      if !$data[key]
        status = self.zadd(key,score,value) unless incr_flag
        nx_flag = 1
      elsif !$data[key].collect{|x| x[0]}.include?(value) 
        status = self.zadd(key,score,value) unless incr_flag
        nx_flag = 1
      else
        nx_flag = -1
      end
    end
    if args.include?("XX")
      if $data[key]
        if $data[key].collect{|x| x[0]}.include?(value) 
          status = self.zadd(key,score,value) unless incr_flag
          xx_flag = 1
        else
          xx_flag = -1
        end
      else
        xx_flag = -1
      end

    end
    if args.include?("CH")
      if nx_flag == 0 and xx_flag == 0
        status = self.zadd(key,score,value) unless incr_flag
      end
    end
    if args.include?("INCR")
      unless nx_flag == -1 or xx_flag == -1 
        return self.zadd(key,score,value,0)
      end
      if nx_flag == -1 or xx_flag == -1
        return Status.new(202)
      end
    end
    status
  end

end