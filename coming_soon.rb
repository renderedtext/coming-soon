require 'sinatra/base'

class ComingSoon < Sinatra::Base

  configure do
    if !File.exist?('config.yml')
      puts "There's no configuration file at config.yml!"
      exit!
    end
    APP_CONFIG = YAML.load_file('config.yml')
  end

  get '/' do
    "Hello #{APP_CONFIG['app_name']}!"
  end
end
