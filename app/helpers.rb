# frozen_string_literal: true

# Helper methods for app controller
module Helpers
  def render_twiml(twiml)
    twiml.text
  end

  def query(path, zip, reps = [])
    "#{path}?ids=#{reps.map(&:bioguide_id).join('-')}&zip=#{zip.tr(' ', '+')}"
  end

  def set_zip_and_reps
    return unless params['zip']
    @zip  = params['zip']
    @reps = PYR.reps { |r| r.address = @zip }.objects
  end

  def set_rep_and_local_office
    return unless params['ids']
    ids     = params['ids'].split('-')
    id      = ids.size > 1 ? ids[params['Digits'].to_i - 1] : ids.first
    @rep    = @reps.where(bioguide_id: id).first
    @office = @rep.office_locations.first
  end

  def list_known_reps_and_gather_input
    Twilio::TwiML::Response.new do |r|
      r.Say 'Hi, welcome to the Phone Your Rep call router.'
      r.Say "We found #{@reps.count} reps who might represent you."
      r.Gather numDigits: '1', action: query('/local-office', @zip, @reps), method: 'get' do |g|
        @reps.each_with_index do |rep, index|
          g.Say "To call #{rep.role} #{rep.official_full}, press #{index + 1}."
        end
      end
    end
  end

  def send_text_with_office_info
    recipient = params['To']
    TwilioClient.new.text recipient do |sms|
      sms.body @rep.official_full
      sms.body @office.address
      sms.body "#{@office.city}, #{@office.state} #{@office.zip}"
      sms.body @office.phone
    end
  end

  def describe_local_office_and_gather_input
    Twilio::TwiML::Response.new do |r|
      r.Say "#{@rep.official_full} has an office about #{@office.distance.round} miles away at "\
        "#{[@office.address, @office.city, @office.state, @office.zip].join(', ')}."
      r.Say "The phone number for this office is #{@office.phone}."
      r.Gather numDigits: '1', action: query('/call-rep', @zip, [@rep]), method: 'get' do |g|
        g.Say 'Press 1 to call this office. Press any other key to hear this again.'
      end
    end
  end

  def place_call_to_local_office
    Twilio::TwiML::Response.new do |r|
      r.Dial TwilioNumber.new(@office.phone).to_s
    end
  end
end
