# frozen_string_literal: true

# Wrapper for the Twilio REST client
class TwilioClient
  attr_reader :caller

  def client
    @_client ||= Twilio::REST::Client.new account_sid, auth_token
  end

  def call(caller:, zip: '')
    client.account.calls.create(
      from:   app_phone_number,
      to:     TwilioNumber.new(caller).to_s,
      url:    url(zip),
      method: 'get'
    )
  end

  def text(recipient)
    account.messages.create(
      from: app_phone_number,
      to:   TwilioNumber.new(recipient).to_s,
      body: yield.to_s
    )
  end

  private

  def account
    @_account ||= client.account
  end

  def account_sid
    @_account_sid ||= ENV['TWILIO_ACCOUNT_SID']
  end

  def auth_token
    @_auth_token ||= ENV['TWILIO_AUTH_TOKEN']
  end

  def url(zip)
    @_url ||= "#{ENV['APP_URL']}/new-call?zip=#{zip}"
  end

  def app_phone_number
    @_app_phone_number ||= TwilioNumber.new(ENV['TWILIO_PHONE_NUMBER']).to_s
  end
end
