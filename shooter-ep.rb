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
  #input = (1..1000000).map { |i| Random.rand(2000).to_i.to_s }
  inputs << input
end
outputs = []

inputs.each do |input|
  scores = input.map { |score| Integer score }
  dp_cache = [[scores[0], [1]], [[scores[0], scores[1]].max, (scores[0] > scores[1] ? [1] : [2])]]

  scores.each_with_index do |score, index|
    if index < 2
      next
    end
    a = (score + dp_cache[index-2][0])
    a_indexes = dp_cache[index-2][1] + [index+1]
    b = dp_cache[index-1][0]
    b_indexes = dp_cache[index-1][1]
    if a > b
      score = [a, a_indexes]
    else
      score = [b, b_indexes]
    end
    dp_cache << score
  end
  outputs << dp_cache[-1][1].join(' ')
end
outputs.each { | output | puts output}