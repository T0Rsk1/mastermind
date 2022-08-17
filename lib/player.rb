# frozen_string_literal: true

require './text'
require './game_tools'

# Player
class Player
  include Text
  include GameTools

  def initialize(game)
    @game = game
  end

  def create_code
    puts enter_code
    input_code(@game.mode)
  end

  def play
    @game.guess = ''
    @game.guess = input_code(@game.mode)
  end
end
