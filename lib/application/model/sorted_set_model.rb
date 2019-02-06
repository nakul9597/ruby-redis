class SortedSetModel

  def zadd(key,score,value)
    if $data[key] == nil
      $data[key] = [[value,score]]
      return 1
    else
      idx = $data[key].bsearch_index {|index_score| index_score[0] == value}
      if idx != nil
        $data[key].delete_at(idx)
        zadd(key,score,value)
        return 0
      end
      index_at = $data[key].bsearch_index {|index_score| index_score[1] >= score}
      if index_at == nil
        $data[key].push([value,score])
        return 1
      end

      loop do 
        if $data[key][index_at] == nil
          $data[key].push([value,score])
          return 1
        end
        if $data[key][index_at][1] == score 
          if $data[key][index_at][0] < value
            index_at += 1
            next
          else
            $data[key].insert(index_at,[value,score])
            return 1
          end
        else
          $data[key].insert(index_at,[value,score])
          return 1
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
    (count_val = $data[key].collect{|val| val[1]}.count &(min..max).to_a.method(:include?))
  end

  def zrange(key,min,max,score = nil)
    return ["*0\r\n"] if !$data[key]
    temp = ""
    $data[key][min.to_i..max.to_i]. each do |node|
      temp += "$#{node[0].size}\r\n#{node[0]}\r\n"
      if score == "WITHSCORES"
        temp += "$#{node[1].size}\r\n#{node[1]}\r\n"
      end
    end
    count_val = temp.scan(/(\r)(\n)/).count
    temp = "*#{count_val/2}\r\n"+temp
    return [temp]
  end

end