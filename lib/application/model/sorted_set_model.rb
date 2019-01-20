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
        value = format_value(value)
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
    score = $data[key].collect{|val| val[1]}.find_index(format_value(value))
    score ? score : Status.new(202)
  end

  def zcount(key,min,max)
    $data[key] ? (count_val = $data[key].collect{|val| val[0]}.count &(min..max).to_a.method(:include?)) : 0
  end

  def zrange(key,min,max,score = nil)
    temp = []
    index_count = 1
    return Status.new(204) if !$data[key][min.to_i..max.to_i]
    $data[key][min.to_i..max.to_i]. each do |node|
      temp.push("#{index_count}) \"#{node[1]}\"")
      (temp.push("#{index_count}) \"#{node[0]}\"");index_count+=1) if score == "withscore"
      index_count += 1
    end
    return temp
  end

  private
  def format_value(value)
    return value[1..-2] if !!value.match(/\A\"(.)+\"\z/)
    value
  end

end