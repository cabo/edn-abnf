require_relative "b64grammar.rb"

class CBOR_DIAG::App_b64
  def self.decode(_, s)
    parser = B64GRAMMARParser.new #  B? XXX
    ast = parser.parse(s)
    if !ast
      raise ArgumentError, "cbor-diagnostic: Parse Error in b64'#{s}':\n" << EDN.reason(parser, s)
    end
    # lazy -- not using parse tree...:
    t = s.gsub(/\s/, '').chars.each_slice(4).map(&:join)
    if last = t[-1]
      last << "=" * (4 - last.size)
    end
    b = t.join.tr("-_", "+/")
    begin
      b.unpack("m0")[0]
    rescue ArgumentError
      raise ArgumentError, "cbor-diagnostic: invalid base64 #{b.inspect}", caller[1..-1]
    end
  end
end
