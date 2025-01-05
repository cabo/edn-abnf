require_relative "dtgrammar.rb"
require 'time'

# Using Time#iso8601 creates the following bugs:
# * dt'1970-01-01T10:00:00' is accepted and gives local time
# * dt'1970-01-01T10:00:00.0Z' gives an integer instead of a float
# Probably should copy over Time#xmlschema and fix that for us.

class CBOR_DIAG::App_dt
  def self.decode(app_prefix, s)
    parser = DTGRAMMARParser.new
    ast = parser.parse(s)
    if !ast
      raise ArgumentError, "cbor-diagnostic: Parse Error in dt'#{s}':\n" << EDN.reason(parser, s)
    end
    frac = ast.has_frac != ""

    t = Time.iso8601(s)
    tv = if frac # t.subsec != 0
      t.to_f
    else
      t.to_i
    end
    case app_prefix
    when 'dt'
      tv
    when 'DT'
      CBOR::Tagged.new(1, tv)
    else
      fail app_prefix
    end
  end
end
