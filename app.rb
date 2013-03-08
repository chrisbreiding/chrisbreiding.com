require 'sinatra'
require 'psych'

get '/' do
  @title = 'Chris Breiding | Web Developer'
  content_yml = File.read('data/content.yml')
  @content = Psych.load(content_yml)
  erb :index
end
