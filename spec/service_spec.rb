require 'rack/test'
require 'minitest/spec'
require 'minitest/autorun'
require_relative '../service'

class ServiceTest < Minitest::Test
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def test_when_requesting_a_compliment_returns_a_200
		get '/'
		assert_equal 200, last_response.status
	end

	def test_when_requesting_a_compliment_returns_a_proper_JSON_response
		get '/'
		assert_includes last_response.content_type, 'application/json'
	end

	def test_when_requesting_a_compliment_returns_json_with_compliment
		get '/'
		json = JSON.parse(last_response.body)
		assert_kind_of Hash, json
		assert json.fetch('compliment')
	end

	def test_when_requesting_a_compliment_returns_json_with_missing_words
		get '/'
		json = JSON.parse(last_response.body)
		assert_kind_of Hash, json
		assert json.fetch('missing_words')
	end
end

# If everything is working
	# Should return a 200 response

	# Should return a json object that looks like this:
	# {
	# 	compliment: '',
	# 	missing_words: ['foo', 'bar', 'spork']
	# }

# If emergencycompliment is not available
	# Should return a 404 response

	# Should return a json object that looks like this:
	# {
	# 	message: 'emergencycompliment is unavailable'
	# }
