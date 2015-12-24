require 'sinatra'
require 'sinatra-contrib'
require 'httparty'
require 'json'

post '/request' do
  message = params[:text].gsub(params[:trigger_word], '').strip

  action, repo = message.split("_").map {|i| i.strip.downcase}
  repo_url = "https://api.github.com/repos/#{repo}"

  case action
  when 'issues'
    resp = HTTParty.get(repo_url)
    resp = JSON.parse resp.body
    respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"
  end
end

def respond_message message
  content_type :json
  {:text => message}.to_json
end
