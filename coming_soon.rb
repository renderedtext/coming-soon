require 'sinatra/base'
require 'active_record'

require 'csv'

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
    validates_uniqueness_of :email
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
    redirect "/?m=email_blank" if params[:email].blank?

    if User.count(:conditions => { :email => params[:email] }) > 0
      redirect "/?m=email_taken"
    end

    @user = User.new(:email => params[:email],
                     :referer  => params[:referer])
    if @user.save
      redirect "/?m=success"
    else
      redirect "/?m=email_invalid"
    end
  end

  get '/backstage' do
    protected!
    @user_count = User.count
    erb :backstage
  end

  get '/backstage/csv' do
    protected!
    csv_content = CSV.generate do |csv|
      User.find_each do |user|
        csv << [user.email]
      end
    end

    headers "Content-Disposition" => "attachment;filename=emails.csv",
            "Content-Type" => "text/csv"
    csv_content
  end

  ##

  helpers do

    def flash_message(message)
      case message
      when "email_blank"
        @notice = "But there is no point if you don't tell us your email."
      when "email_taken"
        @notice = "You're already on the list! Thanks for double interest."
      when "email_invalid"
        @notice = "The format of the email seems odd."
      when "success"
        @success = "Thank you! We promise a nice surprise soon."
      else ""
      end
    end

    def pluralize(count, singular, plural = nil)
      "#{count || 0} " + ((count == 1 || count =~ /^1(\.0+)?$/) ? singular : (plural || singular.pluralize))
    end

    def testing?
      ENV['RACK_ENV'] == "test"
    end

    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Authentication Required")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      return true if testing?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == [APP_CONFIG["admin_username"], APP_CONFIG["admin_password"]]
    end
  end
end
