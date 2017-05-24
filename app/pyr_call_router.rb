# frozen_string_literal: true

require './config/environment'

# API endpoint for Twilio
class PYRCallRouter < Sinatra::Base
  not_found do
    status 404
    '404 not found'
  end

  helpers do
    include Helpers
  end

  before do
    set_zip_and_reps
    set_rep_and_local_office
  end

  get '/' do
    if params['From']
      TwilioClient.new.call(caller: params['From'], zip: params['Body'])
    end
  end

  get '/new-call' do
    render_twiml list_known_reps_and_gather_input
  end

  get '/local-office' do
    send_text_with_office_info
    render_twiml describe_local_office_and_gather_input
  end

  get '/call-rep' do
    if params['Digits'] == '1'
      render_twiml place_call_to_local_office
    else
      render_twiml describe_local_office_and_gather_input
    end
  end
end
