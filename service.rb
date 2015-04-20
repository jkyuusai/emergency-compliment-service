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
	string.split.each do |word|
		wd = normalize(word)
		next if wd.length == 0 || words.key?(wd) || words.key?(wd.downcase)
		missing_words.push(wd)		
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
	(" " + word + " ")
	.gsub(/\.{2,}/,' ')
	.gsub(/(?=[\s\S])-\s/,'')
	.gsub(/\s-(?=[\s\S])/,'')
	.gsub(/\S*\d\S*/,'')
	.gsub(/\d/,'')
	.tr('/',' ')
	.tr('".,+=!','')
	.strip
end
