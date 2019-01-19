class SortedSetController

	def self.zadd(key,score,value)
		if $data[key] == nil
			$data[key] = [[score,value]]
			return 1
		else
			index_at = $data[key].bsearch_index {|index_score| index_score[0] >= score}
			if index_at == nil
				$data[key].push([score,value])
				return 1
			else
				$data[key].insert(index_at,[score,value])
				return 1
			end
		end
	end

	def self.zcard(key)
		$data[key] ? $data[key].size : 0
	end

	def self.zrank(key,value)
		score = $data[key].collect{|val| val[1]}.find_index(value)
		score ? score : Status.new(202)
	end

	def self.zcount(key,min,max)
		$data[key] ? (count_val = $data[key].collect{|val| val[0]}.count &(min..max).to_a.method(:include?)) : 0
	end

	def self.zrange(key,min,max,score = nil)
		temp = []
		index_count = 1
		return Status.new(204) if !$data[key][min.to_i..max.to_i]
		$data[key][min.to_i..max.to_i]. each do |node|
			temp.push("#{index_count}) #{node[1]}")
			(temp.push("#{index_count}) #{node[0]}");index_count+=1) if score == "withscore"
			index_count += 1
		end
	end

end