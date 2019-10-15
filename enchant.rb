def get_em_all(*arr)
  arr.shift.product(*arr)
end

TEST_LINE = "U (smell|look|taste|sound) (beautiful|happy|cheerful) (today|every day)"

def parse(line)
  matches = line.scan(/\(.*?\)/)
  template = line
  matches.each_with_index do |match, index|
    template = template.sub(match, "<#{index}>")
  end
  subbers = matches.map {|m| m.match(/\((.*)\)/)[1].split('|')}
  em_all = get_em_all(*subbers)
  em_all.each do |arr|
    output = template
    arr.each_with_index do |part, index|
      output = output.sub("<#{index}>", part)
    end
    puts output
  end
end

parse(TEST_LINE)