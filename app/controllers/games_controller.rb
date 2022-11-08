# frozen_string_literal: true

require 'net/http'
# Starts the game
class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @message = grid_check(@word.upcase.split(''), @letters.split(''))
    @message = word_check(@word) if @message == 'in the grid'
  end

  private

  def grid_check(attempt, grid)
    attempt.each do |letter|
      return "Sorry, but #{attempt.join} can't be built out of #{grid.join}" unless grid.include?(letter)

      grid.delete_at(grid.index(letter))
    end
    'in the grid'
  end

  def word_check(attempt)
    uri = URI("https://wagon-dictionary.herokuapp.com/#{attempt}")
    dict = Net::HTTP.get(uri)
    parsed_dict = JSON.parse(dict)
    parsed_dict['found'] ? "Congratulations! #{attempt.upcase} is a valid English Word!" : "Sorry, but #{attempt.upcase} doesn't seem to be a valid English word..."
  end
end
