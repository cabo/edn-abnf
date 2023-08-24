# mockup only; needs parser!

class CBOR_DIAG::App_b64
  def self.decode(_, s)
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
