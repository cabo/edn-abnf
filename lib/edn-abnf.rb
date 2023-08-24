require_relative "parser/edn-util.rb"

class EDN
  @@parser = EDNGRAMMARParser.new

  def self.reason(parser, s)
    reason = [parser.failure_reason]
    parser.failure_reason =~ /^(Expected .+) after/m
    reason << "#{$1.gsub("\n", '<<<NEWLINE>>>')}:" if $1
    if line = s.lines.to_a[parser.failure_line - 1]
      reason << line
      reason << "#{'~' * (parser.failure_column - 1)}^"
    end
    reason.join("\n")
  end

  def self.from_edn(s)
    ast = @@parser.parse s
    if !ast
      fail self.reason(@@parser, s)
    end
    ret = EDN.new(ast)
    ret
  end

  attr_accessor :ast, :tree
  def initialize(ast_)
    @ast = ast_
    @tree = ast.ast
  end

  def warn_error(s)
    warn s
    @error = true
  end
  def deep_clone
    Marshal.load(Marshal.dump(self))
  end


end
