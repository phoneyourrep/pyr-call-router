# frozen_string_literal: true

class TwilioNumber
  attr_reader :number

  def initialize(number)
    @number = number.to_s
  end

  def to_s
    return number if number.start_with?('+1')
    @_to_s ||= "+1#{number.delete('-').delete('-').delete('(').delete(')').delete(' ').delete('.')}"
  end
end
