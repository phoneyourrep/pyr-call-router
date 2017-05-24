# frozen_string_literal: true

require './config/environment'

class ApplicationController < Sinatra::Base
  not_found do
    status 404
    '404 not found'
  end

  get '/' do
    'hello world'
  end
end
