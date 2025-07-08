require 'cbor-diagnostic'
module CBOR_DIAG
end

require 'treetop'
require_relative './edngrammar'

class CBOR_DIAG::App_ # fallback!
  def self.decode(app_prefix, s)
    if CBOR::Sequence === s
      args = s.elements
    else
      args = [s]
    end
    CBOR::Tagged.new(999, [app_prefix, args])
  end
end

module EDNGRAMMAR
  const_set(:APPS, Hash.new { |h, k|
              h[k] = begin ::CBOR_DIAG.const_get("App_#{k.downcase}")
                     rescue NameError
                       if $options.fallback
                         ::CBOR_DIAG::App_
                       else
                         raise ArgumentError, "cbor-diagnostic: Unknown application-oriented extension '#{k}'", caller
                       end
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
  def app_parser_level1_diagnostics(e, node)
    outbytes = 0
    if $options.level                                # do manual level-shifting
      input = node.input                             # l1 string
      ol1pos = l1pos = node.interval.begin           # start position
      while outbytes <= e.position
        outbytes += 1
        ol1pos = l1pos
        c1 = input[l1pos]
        if c1 == "\\"           # escapable-s
          c2 = input[l1pos += 1]
          if c2 == "u"          # hexchar-s
            c3 = input[l1pos += 1]
            if c3 == "{"
              l1pos = input.index("}", l1pos)
            else
              if (input[l1pos, 4].to_i(16) & 0xFC00) == 0xD800 # high-surrogate
                l1pos += 6                                     # low-surrogate
              end
              l1pos += 3        # non-surrogate
            end
          end
        end
        l1pos += 1
      end
      intv = ol1pos...l1pos
    else
      intv = node.interval.end...(node.interval.end+1) # default: closing '
      node.elements.each_with_index do |el, i|
        outbytes += el.ast.size
        if outbytes > e.position
          intv = el.interval
          break
        end
      end
    end
    failure_index = intv.begin
    failure_line = node.input.line_of(failure_index)
    failure_column = node.input.column_of(failure_index)
    reason = "** Line #{failure_line}, column #{failure_column}:\n"
    if line = node.input.lines.to_a[failure_line - 1]
      reason << line
      reason << "\n#{'~' * (failure_column - 1)}#{'^' * intv.size}"
    end
    warn reason
  end
end


require 'cbor-diagnostic-app/dt'
require 'cbor-diagnostic-app/ip'
require 'cbor-diagnostic-app/h'
require 'cbor-diagnostic-app/b64'
