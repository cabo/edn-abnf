require_relative "ipgrammar.rb"
require 'ipaddr'

require "cbor-diagnostic-app/0"

class CBOR_DIAG::App_ip
  def self.decode(prefix, s)
    parser = IPGRAMMARParser.new
    s = EDN.to_one_string(prefix, s)
    ast = parser.parse(s)
    if !ast
      raise CBOR_DIAG::AppParseError.new("cbor-diagnostic: Parse Error in ip'#{s}':\n" << EDN.reason(parser, s), parser.failure_index)
    end
    fam, ipv = ast.ast
    case prefix
    when 'ip'
      ipv
    when 'IP'
      CBOR::Tagged.new(fam, ipv)
    else
      fail prefix
    end
  end
end
