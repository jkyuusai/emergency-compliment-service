# emergency-compliment-service

Small Sinatra app that scrapes a compliment from www.emergencycompliment.com using PhantomJS/Capybara and returns a JSON response that includes the compliment and any words from the compliment that don't appear in its included dictionary (the standard wamerican dictionary found in Debian based distros)

Try it out at: https://emergency-compliment-service.herokuapp.com/

##Example
`curl https://emergency-compliment-service.herokuapp.com/`

Result:

`{  
  compliment: "People always think your jeggings are regular jeans.",
  missing_words: [
    "jeggings"
  ]
}`

##Rules applied to missing words
- Capitalized words from compliment match capitalized or uncapitalized words in dictionary (to account for capitalization at start of sentences)
- Uncapitalized words from compliment do not match capitalized words in dictionary (to prevent improper use of proper nouns)
- Possessive/non-possessive forms from compliment are considered different words
- Numbers and ordinal numbers from compliment are ignored
- Words joined by slashes and ellipses from compliment are split
- Hyphenated words from compliment are left hyphenated

##What I learned
- Ruby
- Sinatra
- Rack
- Minitest
- PhantomJS
- Poltergeist
- Capybara
- Heroku Buildpacks

##Didn't wind up using but dealt with a decent bit
- Mechanize
- RSpec
- RestClient

##TODO
- Handle encoding better (goofy quotes on 2-3 compliments still)
- Add tests for and handle connection errors (couldn't figure out how to stub requests and mock error responses for them)
- Move some of the compliment code into its own class, if only to get Capybara::DSL out of the global scope so that it will quit griping
- Speed up service response, guessing PhantomJS is making it slow
- Speed up tests by not forcing a new get for every test
- Storing the word list in a Trie might be faster than a Hash, though a Hash is fast as is so this would be more of a doing for the fun of it kinda thing
