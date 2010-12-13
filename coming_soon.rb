require 'sinatra/base'

class ComingSoon < Sinatra::Base
  get '/' do
    'Hello ComingSoon!'
  end
end
