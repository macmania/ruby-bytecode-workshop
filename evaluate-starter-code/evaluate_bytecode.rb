require_relative 'execute'
require 'optparse'
require 'ostruct'

options = OpenStruct.new

OptionParser.new do |opt|
  opt.on('-file', '--file RUBY_CODE_FILE_PATH', 'Ruby code file path') { |o| options.file_path = o}
  opt.on('-binary', '--binary BINARY_CODE_FILE_PATH', 'Binary data path') { |o| options.binary_file_path = o}
end.parse!

compiler_options = RubyVM::InstructionSequence.compile_option
compiler_options[:inline_const_cache] = false
compiler_options[:peephole_optimization] = false
compiler_options[:specialized_instruction] = false
compiler_options[:operands_unification] = false
compiler_options[:coverage_enabled] = false

return "Must provide code string or file path" if ARGV.count == 0 && options.to_h.empty?

iseq = if options.file_path
         RubyVM::InstructionSequence.compile_file(options.file_path, **compiler_options)
       elsif options.binary_file_path
         RubyVM::InstructionSequence.load_from_binary(File.binread(options.binary_file_path))
       else
         RubyVM::InstructionSequence.compile(ARGV[0], **compiler_options)
       end

execute = Execute.new(iseq)
execute.evaluate
