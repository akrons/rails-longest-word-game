require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def new
    @letters = (1..10).map { |_num| ('A'..'Z').to_a.sample }
    @guess = params[:word]
  end

  def score
    # raise
    @guess = params[:guess].upcase
    @outcome_string = ''
    @outcome = true
    @letters = params[:letters]

    # word doesn't match letters
    @letter_array = @letters.chars
    @guess.chars.each do |char|
      unless @letter_array.include?(char.upcase)
        @outcome_string = "Sorry, but #{@guess} can't be built out of #{@letter_array.join(', ')}"
        @outcome = false
      end
      break unless @outcome

      @letter_array.delete_at(@letter_array.index(char)) if @outcome
    end

    return unless @outcome

    url = "https://wagon-dictionary.herokuapp.com/#{@guess}"
    @outcome_string = if JSON.parse(URI.open(url).read)['found']
                        # check work is english
                        "Congrats! #{@guess} is a valid English word!"
                      else
                        # word is correct
                        "Sorry, but #{@guess} doesn't seem to be a valid English word..."
                      end
  end
end
