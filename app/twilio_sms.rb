# frozen_string_literal: true

# Text message body composer
class TwilioSMS
  def initialize
    @body = []
  end

  def body(string)
    @body << string
  end

  def to_s
    @body.join("\n")
  end
end
