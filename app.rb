require 'rubygems'
require 'bundler/setup'
require 'pp'
Bundler.require

get '/' do
  haml :form
end

post '/' do
  # List users
  access_token = "#{params['app_id']}%7C#{params['app_secret']}"
  res = HTTParty.get("https://graph.facebook.com/#{params['app_id']}/accounts/test-users?access_token=#{access_token}")
  
  # Make each combination friends
  responses = res['data'].combination(2).map do |u1,u2|
    begin
      HTTParty.post("https://graph.facebook.com/#{u1['id']}/friends/#{u2['id']}?access_token=#{u1['access_token']}")
    rescue
      [u1['id'], u2['id']]
    end
  end
  
  haml :response, responses: responses
  
end