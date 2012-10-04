require 'sinatra'
require 'pony'
require 'maruku'
require_relative '../secrets.rb'

get '/' do
  @title = 'Chris Breiding | Web Developer'
  @responsive = true
  @asset_path = 'index'
  @favicon = true
  erb :index
end

post '/send-message' do
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

  '<div class="response valid">Your message has been sent - Thank you!</div>'
end