def get_em_all(*arr)
  arr.shift.product(*arr)
end

TEST_LINE = "U (smell|look|taste|sound) (beautiful|happy|cheerful) (today|every day)"

def parse(line)
  template = line

  matches = line.scan(/\(.*?\)/)
  matches.each_with_index do |match, index|
    template = template.sub(match, "<#{index}>")
  end
  subbers = matches.map {|m| m.match(/\((.*)\)/)[1].split(/[,|]/)}

  return [template] if subbers.empty?

  em_all = get_em_all(*subbers)
  outputs = []

  em_all.each do |arr|
    output = template
    arr.each_with_index do |part, index|
      output = output.sub("<#{index}>", part)
    end
    outputs.push(output)
  end

  return outputs
end

# def interleave(*args)
#   raise 'No arrays to interleave' if args.empty?
#   max_length = args.map(&:size).max
#   output = []
#   max_length.times do |i|
#     args.each do |elem|
#       output << elem[i] if i < elem.length
#     end
#   end
#   output
# end

def interleave(*args)
  raise 'No arrays to interleave' if args.empty?
  max_length = args.map(&:size).max
  # assumes no values coming in will contain nil. using dup because fill mutates
  args.map{|e| e.dup.fill(nil, e.size...max_length)}.inject(:zip).flatten.compact
end

def process_substitutions(lines)
  subs = {}
  lines.each do |line|
    if line.include?('=')
      k, v = line.split('=')
      subs[k] = v
    end
  end
  lines_without = lines.reject {|l| l.include?('=')}

  lines_without.map do |line|
    subs.each do |k, v|
      line.gsub!(k, v)
    end
    line
  end
end  

File.open(ARGV[0]) do |f|
  lines = f.readlines

  lines = process_substitutions(lines)

  puts interleave(*(lines.map {|l| parse(l)}.sort_by {|a| a.size})).shuffle
end