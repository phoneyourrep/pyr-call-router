# frozen_string_literal: true

require 'spec_helper'
# require 'pry'

describe 'The app' do
  context '/' do
    it 'returns 200 OK with an empty body' do
      get '/'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to eq('')
    end
  end

  context '/new-call' do
    it 'returns 200 OK and asks for resubmission without a zip code' do
      get '/new-call'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include(
        '<Say>We had trouble finding your reps with the input you gave us.</Say>'
      )
      expect(last_response.body).to include(
        '<Say>Please try entering your 5 digit zip code again.</Say>'
      )
    end

    it 'returns 200 OK and a list of reps with a zip code as the zip param' do
      get '/new-call?zip=05843'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to match(
        %r{<Say>We found (\d+) reps who might represent you\.</Say>}
      )
    end

    it 'returns 200 OK and a list of reps with a zip code as the Digits param' do
      get '/new-call?Digits=05843'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to match(
        %r{<Say>We found (\d+) reps who might represent you\.</Say>}
      )
    end
  end

  context '/regather-zip' do
    it 'returns 200 OK and asks for resubmission without a zip code' do
      get '/regather-zip'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include(
        '<Say>We had trouble finding your reps with the input you gave us.</Say>'
      )
      expect(last_response.body).to include(
        '<Say>Please try entering your 5 digit zip code again.</Say>'
      )
    end

    it 'returns 200 OK and a list of reps with a zip code as the Digits param' do
      get '/regather-zip?Digits=05843'

      expect(last_response.status).to eq(200)
      expect(last_response.body).to match(
        %r{<Say>We found (\d+) reps who might represent you\.</Say>}
      )
    end
  end
end
