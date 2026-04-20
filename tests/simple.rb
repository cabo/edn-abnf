require 'cbor-diagnostic'
require 'csv'
class String
  def hexi
    bytes.map{|x| "%02x" % x}.join
  end
end

Simple_OK = Set.new(0..23) + Set.new(32..255)

out = CSV.generate do |csv|
  [nil, "foo", "bar".b, *(-10..300)].each do |num|
    if Simple_OK.include? num
      s = CBOR::Simple.new(num)
      csv << ["x", s.inspect, s.to_cbor.hexi]
    else
      d = num.cbor_diagnostic
      s = "simple(#{d})"
      csv << ["-", s, s]
    end
  end
end

puts out


