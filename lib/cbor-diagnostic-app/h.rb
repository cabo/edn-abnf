require_relative "hgrammar.rb"

class CBOR_DIAG::App_h
  def self.decode(_, s)
    parser = HGRAMMARParser.new
    ast = parser.parse(s)
    if !ast
      raise CBOR_DIAG::AppParseError.new("cbor-diagnostic: Parse Error in h'#{s}':\n" << EDN.reason(parser, s), parser.failure_index)
    end
    ast.ast
  end
# s.gsub(/#.*|\s|\/[^\/]*\//, "").chars.each_slice(2).map{ |x| Integer(x.join, 16).chr("BINARY") }.join
end
