require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
  # display a new random grid and a form
    @letters = ('A'..'Z').to_a.sample(8)
    @input = params[:word]
  end

  def score(@input, grid, time)
    if included?(@input.upcase, grid)
      if english_word?(@input)
        score = compute_score(@input, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end
  # in score => The form will be submitted (with POST)
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def compute_score(@input, time_taken)
    time_taken > 60.0 ? 0 : @input.size * (1.0 - time_taken / 60.0)
  end

  def run_game(@input, grid, start_time, end_time)
    result = { time: end_time - start_time }

    score_and_message = score_and_message(@input, grid, result[:time])
    result[:score] = score_and_message.first
    result[:message] = score_and_message.last

    result
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end


end

