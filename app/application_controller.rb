# frozen_string_literal: true

require './config/environment'

# API endpoint for Twilio
class ApplicationController < Sinatra::Base
  not_found do
    status 404
    '404 not found'
  end

  get '/' do
    if params['From']
      TwilioClient.new.call(caller: params['From'], zip: params['Body'])
    end
  end

  get '/new-call' do
    list_known_reps_and_gather_input
  end

  get '/local-office' do
    set_rep_and_local_office
    describe_local_office_and_gather_input
  end

  get '/call-rep' do
    set_rep_and_local_office
    if params['Digits'] == '1'
      place_call_to_local_office
    else
      describe_local_office_and_gather_input
    end
  end

  private

  def render_twiml(twiml)
    twiml.text
  end

  def query(path, zip, reps = [])
    "#{path}?ids=#{reps.map(&:bioguide_id).join('-')}&zip=#{zip}"
  end

  def set_zip_and_reps
    @zip  = params['zip']
    @reps = PYR.reps { |r| r.address = @zip }.objects
  end

  def set_rep_and_local_office
    set_zip_and_reps
    ids     = params['ids'].split('-')
    id      = ids.size > 1 ? ids[params['Digits'].to_i - 1] : ids.first
    @rep    = @reps.where(bioguide_id: id).first
    @office = @rep.office_locations.first
  end

  def list_known_reps_and_gather_input
    set_zip_and_reps
    render_twiml Twilio::TwiML::Response.new do |r|
      r.Say 'Hi, welcome to the Phone Your Rep call router.'
      r.Say "We found #{@reps.count} reps who might represent you."
      r.Gather numDigits: '1', action: query('/local-office', @zip, @reps), method: 'get' do |g|
        @reps.each_with_index do |rep, index|
          g.Say "To call #{rep.role} #{rep.official_full}, press #{index + 1}."
        end
      end
    end
  end

  def describe_local_office_and_gather_input
    render_twiml Twilio::TwiML::Response.new do |r|
      r.Say "#{@rep.official_full} has an office about #{@office.distance.round} miles away at "\
        "#{[@office.address, @office.city, @office.state, @office.zip].join(', ')}."
      r.Say "The phone number for this office is #{@office.phone}."
      r.Gather numDigits: '1', action: query('/call-rep', @zip, [@rep]), method: 'get' do |g|
        g.Say 'Press 1 to call this office. Press any other key to hear this again.'
      end
    end
  end

  def place_call_to_local_office
    render_twiml Twilio::TwiML::Response.new do |r|
      r.Dial TwilioNumber.new(@office.phone).to_s
    end
  end
end
