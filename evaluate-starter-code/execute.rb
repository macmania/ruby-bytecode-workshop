class Execute
  attr_reader :iseq

  Insn = Struct.new(:insn, :operands, :lineno)

  def initialize(iseq)
    @iseq = iseq
    iseq_arr = iseq.to_a

    # code from typeprof-0.15.2
    @locals = iseq_arr[10].reverse
    @fargs_format = iseq_arr[11]
    @catch_table = iseq_arr[12]
    @insns= iseq_arr[13]

    @nisns = parse_iseq(@insns)

    # need to invoke scoping here
    @stack = []
  end

  def parse_iseq(insns)
    ninsns = []
    lineno = 0
    insns.each do |e|
      case e
      when Integer # lineno
        lineno = e
      when Symbol # label or trace like :RUBY_EVENT_LINE
        ninsns << e
      when Array
        insn, *operands = e
        ninsns << Insn.new(insn, operands, lineno)
      else
        raise "unknown iseq entry: #{ e }"
      end
    end
    ninsns
  end

  def evaluate
  end
end
