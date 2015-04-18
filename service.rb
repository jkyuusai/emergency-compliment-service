require 'sinatra'
require 'sinatra/json'

set :server, 'thin'

get '/' do	
	json :key1 => 'this is json'
end