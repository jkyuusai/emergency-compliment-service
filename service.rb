require 'sinatra'
require 'sinatra/json'
require 'capybara'
require 'capybara/poltergeist'

include Capybara::DSL
Capybara.default_driver = :poltergeist

set :server, 'thin'
set :protection, :except => :json_csrf

get '/' do
	json get_compliment
end

def get_compliment
	visit 'http://emergencycompliment.com/'
	compliment = find('.compliment').text
	{:compliment => compliment, :missing_words => []}
end
