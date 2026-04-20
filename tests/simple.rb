require 'cbor-diagnostic'
class String
  def hexi
    bytes.map{|x| "%02x" % x}.join
  end
end

Simple_OK = Set.new(0..23) + Set.new(32..255)
[nil, "foo".b, "bar".b, *(-10..300)].each do |num|
  if Simple_OK.include? num
    s = CBOR::Simple.new(num)
    puts "x,#{s.inspect},#{s.to_cbor.hexi}"
  else
    d = num.cbor_diagnostic
    puts "-,simple(#{d}),simple(#{d})"
  end
end
