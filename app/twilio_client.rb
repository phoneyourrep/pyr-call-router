# frozen_string_literal: true

class TwilioClient
  attr_reader :caller

  def client
    @_client ||= Twilio::REST::Client.new account_sid, auth_token
  end

  def call(caller:, path:, zip: '')
    client.account.calls.create(
      from:   app_phone_number,
      to:     TwilioNumber.new(caller).to_s,
      url:    url(path, zip),
      method: 'get'
    )
  end

  def text(to:, body:)
    account.messages.create(
      from: app_phone_number,
      to:   to,
      body: body
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

  def url(path, zip)
    "#{ENV['APP_URL']}#{path}?zip=#{zip}"
  end

  def app_phone_number
    '+16176525346'
  end
end
