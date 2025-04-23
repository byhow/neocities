class Numeric
  ONE_MEGABYTE = 1000000

  def roundup(nearest=10)
    self % nearest == 0 ? self : self + nearest - (self % nearest)
  end

  def to_mb
    self/ONE_MEGABYTE.to_f
  end

  def to_bytes_pretty
    computed = nil
    unit = nil
    {
      'B'  => 1000,
      'KB' => 1000 * 1000,
      'MB' => 1000 * 1000 * 1000,
      'GB' => 1000 * 1000 * 1000 * 1000,
      'TB' => 1000 * 1000 * 1000 * 1000 * 1000
    }.each_pair { |e, s|
      if self < s
        computed = (self.to_f / (s / 1000)).round(2)
        unit = e
        break
      end
    }
    computed = computed.to_i if computed.modulo(1) == 0.0

    "#{computed} #{unit}"
  end

  def to_gigabytes_pretty
    self.to_gigabytes.to_s + ' GB'
  end

  def to_gigabytes
    self / (1000**3)
  end

  def to_comma_separated
    self.to_i.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
  end

  def format_large_number
    return self.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    if self > 9999
      if self > 999999999
        unit_char = 'B' #billion
        unit_amount = 1000000000.0
      elsif self > 999999
        unit_char = 'M' #million
        unit_amount = 1000000.0
      elsif self > 9999
        unit_char = 'K' #thousand
        unit_amount = 1000.0
      end

      self_divided = self.to_f / unit_amount
      self_rounded = self_divided.round(1)

      if self_rounded.denominator == 1
        return sprintf ("%.0f" + unit_char), self_divided
      else
        return sprintf ("%.1f" + unit_char), self_divided
      end
    else
      if self > 999
        return self.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
      else
        return self
      end
    end
  end

  def to_space_pretty
    to_bytes_pretty
  end

  def not_an_integer?
    !self.integer?
  end
end
