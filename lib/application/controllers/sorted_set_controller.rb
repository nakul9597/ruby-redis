class SortedSetController

	def self.zadd(key,score,value)
		if $data[key] == nil
			$data[key] = [[score,value]]
			return 1
		else
			index_at = $data[key].bsearch_index {|index_score| index_score[0] >= score}
			if index_at == nil
				$data[key].push([score,value])
			else
				$data[key].insert(index_at,[score,value])
			end
		end
	end

	def self.zcard(key)
		return $data[key].size
	end

	def self.zrank(key,value)
		return $data[key].collect{|val| val[1]}.find_index(value)
	end

	def self.zcount(key,min,max)
		return $data[key].collect{|val| val[0]}.count &(min..max).to_a.method(:include?)
	end

	def self.zrange(key,min,max)
		temp = []
		$data[key].each_with_index do |val,idx|
			temp.push("#{idx+1}) #{val[1]}") if (min..max).to_a.include?(val[0])
		end
		return temp
	end

end