class SortedSetModel

  def zadd(key,score,value)
    if $data[key] == nil
      $data[key] = [[score,value]]
      return 1
    else
      index_at = $data[key].bsearch_index {|index_score| index_score[0] >= score}
      if index_at == nil
        $data[key].push([score,value])
        return 1
      else
        if !$data[key].collect{|val| val[1]}.include?(value)
          $data[key].insert(index_at,[score,value])
        else
          return 0
        end
        return 1
      end
    end
  end

  def zcard(key)
    $data[key] ? $data[key].size : 0
  end

  def zrank(key,value)
    return Status.new(202) if !$data[key]
    $data[key].collect{|val| val[1]}.find_index(value)
  end

  def zcount(key,min,max)
    return 0 if !$data[key]
    (count_val = $data[key].collect{|val| val[0]}.count &(min..max).to_a.method(:include?))
  end

  def zrange(key,min,max,score = nil)
    return ["*0\r\n"] if !$data[key]
    temp = ""
    $data[key][min.to_i..max.to_i]. each do |node|
      temp += "$#{node[1].size}\r\n#{node[1]}\r\n"
      if score == "WITHSCORES"
        temp += "$#{node[0].size}\r\n#{node[0]}\r\n"
      end
    end
    count_val = temp.scan(/(\r)(\n)/).count
    temp = "*#{count_val/2}\r\n"+temp
    return [temp]
  end

end