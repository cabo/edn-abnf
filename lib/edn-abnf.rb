require_relative "parser/edn-util.rb"
require_relative "cbor-diag-support.rb"

class EDN
  @@parser = EDNGRAMMARParser.new

  def self.reason(parser, s)
    s = s.to_str
    reason = [parser.failure_reason]
    parser.failure_reason =~ /^(Expected .+) after ./m
    expected = $1
    if line = s.lines.to_a[parser.failure_line - 1]
      reason << "#{$1.gsub("\n", '<<<NEWLINE>>>')}:" if expected
      reason << line
      reason << "#{'~' * (parser.failure_column - 1)}^"
    end
    reason.join("\n")
  end

  def self.to_one_string(prefix, s)
    begin
      s.to_str
    rescue NoMethodError => e
      raise ArgumentError.new("cbor-diagnostic #{prefix}<<>>: #{e}: #{s.inspect}")
    end
  end

  def self.from_edn(s)
    s = s.to_str
    ast = @@parser.parse s
    if !ast
      raise ArgumentError, "Parse Error:\n" << self.reason(@@parser, s)
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
