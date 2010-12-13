require 'sinatra/base'
require 'active_record'


def load_configuration(file, name)
  if !File.exist?(file)
    puts "There's no configuration file at #{file}!"
    exit!
  end
  const_set(name, YAML.load_file(file))
end

class ComingSoon < Sinatra::Base

  configure do
    load_configuration("config.yml", "APP_CONFIG")
    load_configuration("database.yml", "DB_CONFIG")

    ActiveRecord::Base.establish_connection(
      :adapter  => DB_CONFIG['adapter'],
      :host     => DB_CONFIG['host'],
      :username => DB_CONFIG['username'],
      :password => DB_CONFIG['password'],
      :database => DB_CONFIG['name']
    )
  end

  class User < ActiveRecord::Base
    validates_presence_of :email
    validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end

  before do
    @app_name = APP_CONFIG['app_name']
  end

  get '/' do
    flash_message(params[:m])
    erb :index
  end

  post '/create' do
    @user = User.new(:email => params[:email],
                     :referer  => params[:referer])
    if @user.valid?
      redirect "/?m=success"
    else
      redirect "/?m=email_invalid"
    end
  end

  ##

  helpers do

    def flash_message(message)
      case message
      when "email_blank"
        @notice = "But there is no point if you don't tell us your email."
      when "email_invalid"
        @notice = "The format of the email seems odd. "
      when "success"
        @success = "Thank you! We promise a nice surprise soon."
      else ""
      end
    end
  end
end
