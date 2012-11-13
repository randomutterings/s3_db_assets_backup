def number_to_human_size(number)
  return nil if number.nil?

  storage_units_format = '%n %u'

  if number.to_i < 1024
    unit = number > 1 ? 'Bytes' : 'Byte'
    return storage_units_format.gsub(/%n/, number.to_i.to_s).gsub(/%u/, unit)
  else
    max_exp  = 4 # The number of units - 1
    number   = Float(number)
    exponent = (Math.log(number) / Math.log(1024)).to_i # Convert to base 1024
    exponent = max_exp if exponent > max_exp # we need this to avoid overflow for the highest unit
    number  /= 1024 ** exponent

    unit = %w(Byte KB MB GB TB)[exponent]
    return storage_units_format.gsub(/%n/, number.round(2).to_s).gsub(/%u/, unit)
  end
end