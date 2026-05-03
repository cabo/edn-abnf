require 'cbor-diagnostic'
require 'treetop'
require_relative './testformatgrammar'
require 'neatjson'

class Treetop::Runtime::SyntaxNode
  def ast
    text_value
  end
end

class EDN
  class Tests
    @@parser = TESTFORMATGRAMMARParser.new

    def self.reason(parser, s)
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

    def self.from_csv(s)
      ast = @@parser.parse s
      if !ast
        raise ArgumentError, "Parse Error:\n" << self.reason(@@parser, s)
      end
      ret = EDN::Tests.new(ast)
      ret
    end

    attr_accessor :ast, :tree
    def initialize(ast_)
      @ast = ast_
      @tree = ast.ast
    end

  end
end

result = EDN::Tests.from_csv(ARGF.read).tree
puts JSON.neat_generate(result, after_comma: 1, after_colon: 1)
