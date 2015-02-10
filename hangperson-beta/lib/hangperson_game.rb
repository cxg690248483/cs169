class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  attr_accessor :word, :guesses, :wrong_guesses
  def initialize(new_word)
    @word = new_word.downcase
    @guesses = ""
    @wrong_guesses = ""
    @guess_times = 0
  end
  
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end
  
  def guess(guess_word)
    if guess_word == nil or (guess_word =~ /[A-Za-z]/) == nil
      raise ArgumentError
    end
    if @guesses.include? guess_word or @wrong_guesses.include? guess_word
      return false
    end

    guess_word = guess_word.downcase

    if @word.include? guess_word
      @guesses += guess_word
    else
      @wrong_guesses += guess_word
    end
    @guess_times += 1
  end

  def word_with_guesses
    curr_guess = ""
    @word.split("").each do |c|
      if @guesses.include? c
        curr_guess += c
      else
        curr_guess += '-'
      end
    end
    return curr_guess
  end

  def check_win_or_lose
    if self.word_with_guesses.eql? @word
      return :win
    elsif @guess_times >= 7
      return :lose
    else
      return :play
    end
  end
end

