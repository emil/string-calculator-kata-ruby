class StringCalculator

  def add(numbers)
    
    return 0 if numbers.nil? || numbers == ''

    values_sum(numbers)
  end

  private

  def values_sum(numbers)
    delimiters, payload = partition_delimiters_and_the_rest(numbers)

    numbers = payload.split(make_delimiters_regexp(delimiters))

    values = []
    numbers.each {|e|
      sv = single_number_value(e)
      return false unless sv
      values << sv if sv <= 1000
    }
    negative_values = values.select {|n| n < 0 }
    raise ArgumentError, "Negative value #{negative_values}" unless negative_values.empty?
    
    values.reduce(:+)
  end

  def single_number_value(numbers)
    if /\A[-+]?\d+\z/ =~ numbers
      sv = numbers.to_i      
      return sv
    end
    false
  end

  def partition_delimiters_and_the_rest(numbers)
    default_delimiters = [',','\n']
    if /\A\/\/(.*?)\\n/ =~ numbers
      matched = $1
      rest = $'
      multiple_delimiters = matched.scan /\[.+\]/
      if multiple_delimiters.any?
        [multiple_delimiters | default_delimiters, rest]
      else
        [[matched] | default_delimiters, rest]
      end
    else
      [default_delimiters, numbers]
    end
  end
  
  def make_delimiters_regexp(delimiters)
    groups = '(' + (delimiters.join '|') + ')'
    /[#{Regexp.escape(groups)}]+/
  end

end
