require 'sinatra'
require 'sinatra/json'

set :server, 'thin'

get '/' do	
	json :compliment => 'a compliment', :missing_words => []
end