module CBOR
  Box = Struct.new(:value, :options) do
    def to_s
      value.to_s
    end
    def inspect
      "#<CBOR::Box #{self.class} value=#{value.inspect}, options=#{options.inspect}>"
    end
    def self.from_number(n, options={})
      case n
      when Box
        n.class.new(n.value, n.options.merge(options))
      when ::Integer
        Ibox.new(n, options.dup)
      when ::Float
        Fbox.new(n, options.dup)
      else
        raise ArgumentError, "cbor-diagnostic: can't box number from #{n.inspect}':\n"
      end
    end
    def to_cbor
      CBOR.encode(value)
    end
    def cbor_diagnostic(opts = {})
      ret = value.cbor_diagnostic(opts)
      if ei = options[:ei]
        ret << "_#{ei}"
      end
      ret
    end
  end

  class Ibox < Box
    INTEGER_EI = {
      "i" => [23, 0],
      "0" => [0xFF, 1],
      "1" => [0xFFFF, 2],
      "2" => [0xFFFFFFFF, 4],
      "3" => [0xFFFFFFFFFFFFFFFF, 8]
    }
    def make_head(ib, plusbytes, d)
      case plusbytes
      when 0
        [ib + d].pack("C")
      when 1
        [ib + 24, d].pack("CC")
      when 2
        [ib + 25, d].pack("Cn")
      when 4
        [ib + 26, d].pack("CN")
      when 8
        [ib + 27, d].pack("CQ>")
      else
        raise ArgumentError, "cbor-diagnostic: #{plusbytes} plusbytes when encoding head\n"
      end
    end

    def to_cbor
      if ei = options[:ei]
        maxval, plusbytes = INTEGER_EI[ei]
        raise ArgumentError, "cbor-diagnostic: unknown encoding indicator _#{ei} for Integer\n" unless maxval
        d = value
        ib = if d < 0
               d = -1-d
               0x20
             else
               0x00
             end
        raise ArgumentError, "cbor-diagnostic: #{value} doesn't fit into encoding indicator _#{ei}':\n" unless d <= maxval

        make_head(ib, plusbytes, d)

        # s = bignum_to_bytes(d)
        # head(0xc0, TAG_BIGNUM_BASE + (ib >> 5))
        # head(0x40, s.bytesize)
      else
        CBOR.encode(value)
      end
    end
  end
  class Fbox < Box
    FLOAT_EI = {
      "1" => 2,
      "2" => 4,
      "3" => 8
    }
    def make_float(plusbytes, fv)
      ret =
        if fv.nan?
          # | Format   | Sign bit | Exponent | Significand | Zero
          # | binary16 |        1 |        5 |          10 | 42
          # | binary32 |        1 |        8 |          23 | 29
          # | binary64 |        1 |       11 |          52 | 0
          ds = [fv].pack("G")
          firstword = ds.unpack("n").first
          raise "NaN exponent error #{firstword}" unless firstword & 0x7FF0 == 0x7FF0
          iv = ds.unpack("Q>").first
          ret = case plusbytes
                when 2
                  if iv & 0x3ffffffffff == 0 # 42 zero, 10 bits fit in half
                    [0xf9, (firstword & 0xFC00) + ((iv >> 42) & 0x3ff)].pack("Cn")
                  end
                when 4
                  if iv & 0x1fffffff == 0 # 29 zero, 23 bits fit in single
                    [0xfa, (ds.getbyte(0) << 24) + ((iv >> 29) & 0xffffff)].pack("CN")
                  end
                when 8
                  "\xfb".b << ds
                end
        else
          if plusbytes == 8
            [0xfb, fv].pack("CG") # double-precision
          else
            ss = [fv].pack("g")         # single-precision
            if ss.unpack("g").first == fv
              if plusbytes == 4
                "\xfa".b << ss
              else
                if hs = Half.encode_from_single(fv, ss)
                  "\xf9".b << hs
                end
              end
            end
          end
        end
      raise ArgumentError, "cbor-diagnostic: make_float #{plusbytes.inspect} #{fv.inspect}" unless ret
      ret
    end

    def to_cbor
      if ei = options[:ei]
        plusbytes = FLOAT_EI[ei]
        raise ArgumentError, "cbor-diagnostic: unknown encoding indicator _#{ei} for Float':\n" unless plusbytes
        make_float(plusbytes, value)
      else
        CBOR.encode(value)
      end
    end
  end

end
