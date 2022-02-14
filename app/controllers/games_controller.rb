require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    # def generate_grid(grid_size)
    #   letters = ("A".."Z").to_a
    #   counter = 0
    #   grid = []
    #   until counter == grid_size
    #     grid << letters.sample
    #     counter += 1
    #   end
    #   return grid
    # end

    @letters = ("A".."Z").to_a.sample(10)
  end

  def score
    def get_checked(attempt)
      url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
      json_file = URI.open(url).read
      json_doc = JSON.parse(json_file)
      return json_doc["found"]
    end

    def in_grid_once?(attempt, grid)
      attempt.upcase.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
    end

    def checker(attempt, grid)
      if in_grid_once?(attempt, grid)
        if get_checked(attempt)
          return [attempt.size, "well done"]
        else
          return [0, "not an English word"]
        end
      else
        return [0, "not in the grid"]
      end
    end

    def run_game(attempt, grid)
      result = {}

      checker = checker(attempt, grid)
      result[:score] = checker.first
      result[:message] = checker.last

      return result
    end

    @score = run_game(params[:word], params[:letters_array])
    @message = run_game(params[:word], params[:letters_array])
  end
end
