Dir.mkdir 'binary_data' unless Dir.exist?('binary_data')
options = RubyVM::InstructionSequence.compile_option
options[:inline_const_cache] = false
options[:peephole_optimization] = false
options[:specialized_instruction] = false
options[:operands_unification] = false
options[:coverage_enabled] = false

Dir.foreach('code') do |file|
  next unless file.end_with?('.rb')
  filename = file.match(/(task[0-9]).rb/i).captures.first

  f = File.open("binary_data/#{filename}", 'wb')
  f.write(RubyVM::InstructionSequence.compile_file("code/#{file}", **options).to_binary)

  f.close
end
