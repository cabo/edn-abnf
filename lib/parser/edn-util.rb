require 'cbor-diagnostic'
module CBOR_DIAG
end

require 'treetop'
require_relative './edngrammar'

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
require 'cbor-diagnostic-app/h'
require 'cbor-diagnostic-app/b64'
