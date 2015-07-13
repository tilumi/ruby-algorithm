require 'pp'
num_of_input_size = nil
while num_of_input_size.nil?
  begin
    num_of_input_size = Integer(STDIN.gets)
  rescue ArgumentError
    puts 'Please input a number.'
  end
end
inputs = []
(1..num_of_input_size).each do |i|
  input = STDIN.gets.split(' ')
  # input = (1..200).map { |i| Random.rand(2000).to_i.to_s }
  inputs << input
end


results = []
inputs.each do |input|
  dp_cache = []
  plates = []
  input.each_with_index do |plate_str, index|
    plates << [index, Integer(plate_str)]
  end

  # p plates
  first_row_of_dp_cache = []
  plates.reverse.each_with_index do |plate, index|
    dp_element = {value_sum: 0, permutation_counts: 0, acc_value_sum: 0, acc_permutation_counts: 0}
    dp_element[:value_sum] = plate[1]
    dp_element[:permutation_counts] = 1
    dp_element[:acc_value_sum] = (index>0 ? first_row_of_dp_cache[0][:acc_value_sum] : 0) + dp_element[:value_sum]
    dp_element[:acc_permutation_counts] = (index > 0 ? first_row_of_dp_cache[0][:acc_permutation_counts] : 0) + dp_element[:permutation_counts]
    first_row_of_dp_cache.unshift(dp_element)
  end
  dp_cache << first_row_of_dp_cache

  (1..plates.length-1).each do |i|
    row = []
    dp_cache << row
    (plates.length-1).downto(0).each do |j|
      plate = plates[j]
      dp_element = {value_sum: 0, permutation_counts: 0, acc_value_sum: 0, acc_permutation_counts: 0}
      if i > 0 and j < plates.length-1
        ref_dp_element = dp_cache[i-1][j+1]
        dp_element[:value_sum] = plate[1] * ref_dp_element[:acc_permutation_counts] + ref_dp_element[:acc_value_sum]
        dp_element[:permutation_counts] = ref_dp_element[:acc_permutation_counts]
        dp_element[:acc_value_sum] = (row.length > 0 ? row[0][:acc_value_sum] : 0) + dp_element[:value_sum]
        dp_element[:acc_permutation_counts] = (row.length > 0 ? row[0][:acc_permutation_counts] : 0) + dp_element[:permutation_counts]
      end
      row.unshift(dp_element)
    end
  end

  # p dp_cache

  total = 0
  length_of_plates = plates.length

  dp_cache.each_with_index do |row, i|
    divisor = length_of_plates.downto(length_of_plates-i-1).to_a.inject(:*)
    # p "divisor: #{divisor}"
    row.each_with_index do |element, j|
      if i < length_of_plates-1
        # p "multiply: #{length_of_plates-(i+j+1)}"
        # p "element: #{element[:value_sum]}"
        # p "before total: #{total}"
        # p "add to total: #{(((length_of_plates-(i+j+1)) * element[:value_sum])/divisor.to_f)}"
        total = total + (((length_of_plates-(i+j+1)) * element[:value_sum])/divisor.to_f)
        # p "after total: #{total}"
      end
    end
  end
  divisor = length_of_plates.downto(1).to_a.inject(:*)
  total += ((dp_cache[length_of_plates-1][0][:value_sum])/divisor.to_f)
  results << total
end

results.each { |result| p result}
