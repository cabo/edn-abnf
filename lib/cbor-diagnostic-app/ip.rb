require_relative "ipgrammar.rb"
require 'ipaddr'

require "cbor-diagnostic-app/0"

class CBOR_DIAG::App_ip
  def self.decode(app_prefix, s)
    parser = IPGRAMMARParser.new
    ast = parser.parse(s)
    if !ast
      raise CBOR_DIAG::AppParseError.new("cbor-diagnostic: Parse Error in ip'#{s}':\n" << EDN.reason(parser, s), parser.failure_index)
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
