# frozen_string_literal: true

require './config/environment'

# API endpoint for Twilio
class PYRCallRouter < Sinatra::Base
  not_found { '404 not found' }

  helpers Helpers

  before do
    set_zip_and_reps
    set_rep_and_local_office
  end

  get '/' do
    if params['From'] && params['Body']
      TwilioClient.new.call(caller: params['From'], zip: params['Body'])
    end
  end

  get '/new-call' do
    render_twiml list_known_reps_and_gather_input
  end

  get 'regather-zip' do
    render_twiml list_known_reps_and_gather_input(new_call: false)
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
