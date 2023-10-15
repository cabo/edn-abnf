require_relative "dtgrammar.rb"
require 'time'

# Using Time#iso8601 creates the following bugs:
# * dt'1970-01-01T10:00:00' is accepted and gives local time
# * dt'1970-01-01T10:00:00.0Z' gives an integer instead of a float
# Probably should copy over Time#xmlschema and fix that for us.

class CBOR_DIAG::App_dt
  def self.decode(_, s)
    parser = DTGRAMMARParser.new
    ast = parser.parse(s)
    if !ast
      raise ArgumentError, "cbor-diagnostic: Parse Error in dt'#{s}':\n" << EDN.reason(parser, s)
    end
    # ast.ast

    t = Time.iso8601(s)
    if t.subsec != 0
      t.to_f
    else
      t.to_i
    end
  end
end
