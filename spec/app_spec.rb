# frozen_string_literal: true

require 'spec_helper'

describe '/' do
  it 'returns 200 OK with an empty body' do
    get '/'

    expect(last_response.status).to eq(200)
    expect(last_response.body).to eq('')
  end
end
