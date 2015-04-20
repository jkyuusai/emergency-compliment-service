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

	def test_get_dictionary_should_return_a_hash_of_words
		words = get_dictionary
		assert_kind_of Hash, words
		assert(words)
	end

	def test_get_missing_words_returns_an_array
		compliment = "Strangers all wannar sit next to you on the bus."
		missing_words = get_missing_words(compliment)
		
		assert_kind_of Array, missing_words
	end

	def test_get_missing_words_should_return_any_words_not_found_in_the_dictionary
		compliment = "Strangers all wannar sit next to you on the bus."
		missing_words = get_missing_words(compliment)

		assert_equal(missing_words, ["wannar"])
	end

	def test_get_missing_words_should_check_if_word_exists_in_lowercase_form_if_capitalized_form_is_not_found_in_dictionary
		compliment = "There Is no bluh reason to Panic."
		missing_words = get_missing_words(compliment)

		assert_equal(missing_words, ["bluh"])
	end

	def test_after_a_string_is_passed_through_normalize_it_should_have_ellipses_replaced_with_a_space
		assert_equal "except Gary", normalize("...except Gary")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_have_forward_slash_replaced_with_a_space
		assert_equal "and or", normalize("and/or")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_dashes_that_are_not_part_of_hyphenated_words
		assert_equal "kiwi", normalize("kiwi- ")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_any_double_quotes
		assert_equal "said", normalize("\"said\"")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_any_periods
		assert_equal "Dr", normalize("Dr.")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_any_commas
		assert_equal "say what", normalize("say, what")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_any_plus_signs
		assert_equal "youme", normalize("you+me")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_any_equal_signs
		assert_equal "youme", normalize("you=me")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_any_exclamation_points
		assert_equal "approve", normalize("approve!")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_any_numbers
		assert_equal "pigs", normalize("3 pigs")
	end

	def test_after_a_string_is_passed_through_normalize_it_should_not_contain_any_ordinals
		assert_equal "place", normalize("3rd place")
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
