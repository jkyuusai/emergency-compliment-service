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
	{:compliment => compliment, :missing_words => get_missing_words(compliment)}
end

def get_missing_words(string)
	missing_words = []
	words = get_dictionary
	normalize(string).split.each do |word, index|
		next if word.length == 0 || words.key?(word) || words.key?(word.downcase)
		missing_words.push(word)		
	end
	return missing_words	
end

def get_dictionary
	words = {}
	File.open('./american-english') do |fp|
	  fp.each do |line|
	    words[normalize(line)] = true
	  end
	end
	return words
end

def normalize(word)
	word.strip.gsub(/\.\.\./,' ').gsub(/(?=[\s\S])-(?<=[\s\S])/,'').tr('/',' ').tr('".,+=!','')
end
