require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = []
    @letters << ('A'..'Z').to_a.sample while @letters.size < 10
  end

  def score
    if params[:word]
      @word = params[:word].upcase
    end
    if params[:grid]
      @grid = params[:grid]
    end
    if in_grid?(@grid, @word) == false
      @answer = 'not_in_grid'
    elsif english_word?(@word) == false
      @answer = 'not_english_word'
    else
      @answer = 'valid'
    end
  end

  private

  def in_grid?(grid, word)
    array_grid = grid.split(' ')
    word.each_char do |char|
      if array_grid.include?(char)
        array_grid.delete_at(array_grid.index(char))
      else
        return false
      end
    end
    true
  end

  def english_word?(word)
    api_url = "https://wagon-dictionary.herokuapp.com/#{word.downcase}"
    validation_string = URI.open(api_url).read
    result = JSON.parse(validation_string)
    result["found"] == true
  end
end
