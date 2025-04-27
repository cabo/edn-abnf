require 'cbor-diagnostic'
module CBOR_DIAG
end

require 'treetop'
require_relative './edngrammar'

module EDNGRAMMAR
  const_set(:APPS, Hash.new { |h, k|
              h[k] = begin ::CBOR_DIAG.const_get("App_#{k.downcase}")
                     rescue NameError
                       raise ArgumentError, "cbor-diagnostic: Unknown application-oriented extension '#{k}'", caller
                     end
            }) unless const_defined?(:APPS)
end

class Treetop::Runtime::SyntaxNode
  def ast
    fail "undefined_ast #{inspect}"
  end
  def ast1                      # devhack
    "#{inspect[10..20]}--#{text_value[0..15]}"
  end
  def hex_value
    text_value.to_i(16)
  end
end


require 'cbor-diagnostic-app/dt'
require 'cbor-diagnostic-app/ip'
require 'cbor-diagnostic-app/h'
require 'cbor-diagnostic-app/b64'
