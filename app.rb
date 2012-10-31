require 'sinatra'
require 'pony'
require 'maruku'
require 'rack-flash'
require_relative '../secrets.rb'

enable :sessions
use Rack::Flash

helpers do
  def send_message
    Pony.mail({
      to: 'chris@chrisbreiding.com',
      subject: "Website Contact Form Submission from #{params[:name]}",
      html_body: erb(:email, layout: false),

      via: :smtp,
      via_options: {
        address: 'smtp.gmail.com',
        port: '587',
        enable_starttls_auto: true,
        user_name: 'admin@chrisbreiding.com',
        password: GAPPS_PW,
        authentication: :plain,
        domain: 'chrisbreiding.com'
      }
    })
  end
end

get '/' do
  @title = 'Chris Breiding | Web Developer'
  portfolio_yml = File.read('data/portfolio.yml')
  @portfolio = Psych.load(portfolio_yml)
  erb :index
end

post '/send-message' do

  message_response = 'Your message has been sent - Thank you!'

  if request.xhr?
    send_message
    message_response
  else
    errors = {}
    all_valid = true

    [:name, :email, :message].each do |field|
      if params[field].empty?
        all_valid = false
        errors[field] = true
      end
      flash[field] = params[field]
    end

    flash[:errors] = errors

    if all_valid
      send_message
      flash[:message_response] = message_response
    end

    redirect to('/#contact'), 303
  end

end