# mockup only; needs parser!

class CBOR_DIAG::App_h
  def self.decode(_, s)
    s.gsub(/#.*|\s|\/[^\/]*\//, "").chars.each_slice(2).map{ |x| Integer(x.join, 16).chr("BINARY") }.join
  end
end
