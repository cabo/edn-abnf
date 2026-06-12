require "cbor-diagnostic-app/0"

class CBOR_DIAG::Helper
  def self.decode_string(app_prefix, s, to_text = false)
    ret = if CBOR::Sequence === s
            args = s.elements
          else
            args = [s]
          end.map { |el|
      unless String === el || el.respond_to?(:value) && String === el.value
        raise ArgumentError.new("cbor-diagnostic: #{app_prefix}<<>>: #{el.cbor_diagnostic} not a string: Argument Error")
      end
      el.b
    }.join.b # .b needed so empty array becomes byte string, too
    if to_text
      ret = ret.force_encoding(Encoding::UTF_8)
    end
    ret
  end
end

class CBOR_DIAG::App_b1
  def self.decode(app_prefix, s)
    CBOR_DIAG::Helper.decode_string(app_prefix, s, false)
  end
end

class CBOR_DIAG::App_t1
  def self.decode(app_prefix, s)
    CBOR_DIAG::Helper.decode_string(app_prefix, s, true)
  end
end
