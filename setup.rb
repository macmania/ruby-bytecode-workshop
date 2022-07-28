Dir.mkdir 'binary_data'
Dir.foreach('code') do |file|
  next unless file.end_with?('.rb')
  filename = file.match(/(task[0-9]).rb/i).captures.first

  file = File.open("binary_data/#{filename}", 'wb')
  file.write(RubyVM::InstructionSequence.compile_file(file).to_binary)

  file.close
end
