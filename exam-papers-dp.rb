num_of_input_size = nil
while num_of_input_size.nil?
  begin
    num_of_input_size = Integer(STDIN.gets)
  rescue ArgumentError
    puts 'Please input a number.'
  end
end

inputs = []
results = []
(1..num_of_input_size).each do |i|
  input = {}
  input[:num_of_students] = Integer STDIN.gets
  friends = {}
  STDIN.gets.split(' ').map { |e| Integer e }.each_slice(2) do |a, b|
    friends[a] = [] unless friends[a]
    friends[a] << b
  end
  input[:friends] = friends
  inputs << input
end

NON_PAPER = 0
PAPER_A = 1
PAPER_B = 2

inputs.each do |input|
  is_invalid = false
  num_of_students = input[:num_of_students]
  firends_list = input[:friends]
  # p firends_list
  papers = Array.new(num_of_students) { |i| NON_PAPER }
  students = (0..num_of_students-1).to_a
  (0..num_of_students-1).each do |student|
    friends = firends_list[student]
    if papers[student] == NON_PAPER
      papers[student] = PAPER_A
    end
    paper_for_friend = papers[student] == PAPER_A ? PAPER_B : PAPER_A

    if friends
      friends.each do |friend|
        friend_paper = papers[friend]
        if friend_paper == NON_PAPER
          papers[friend] = paper_for_friend
        elsif friend_paper != paper_for_friend
          is_invalid = true
          break
        end
      end
    end
    # p papers
    break if is_invalid
  end
  if is_invalid
    students_with_paper_a = []
    students_with_paper_b = []
  else
    students_with_paper_a = papers.each_index.select { |i| papers[i] == PAPER_A }
    students_with_paper_b = papers.each_index.select { |i| papers[i] == PAPER_B }
  end
  results << [students_with_paper_a, students_with_paper_b]
end

results.each do |result|
  print '['
  print result[0].join(' ')
  print ']'
  STDOUT.flush
  puts ''
  print '['
  print result[1].join(' ')
  print ']'
  STDOUT.flush
  puts ''
end