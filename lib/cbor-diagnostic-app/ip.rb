require_relative "ipgrammar.rb"
require 'ipaddr'

class CBOR_DIAG::App_ip
  def self.decode(app_prefix, s)
    parser = IPGRAMMARParser.new
    ast = parser.parse(s)
    if !ast
      raise ArgumentError, "cbor-diagnostic: Parse Error in ip'#{s}':\n" << EDN.reason(parser, s)
    end
    fam, ipv = ast.ast
    case app_prefix
    when 'ip'
      ipv
    when 'IP'
      CBOR::Tagged.new(fam, ipv)
    else
      fail app_prefix
    end
  end
end
