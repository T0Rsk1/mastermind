# frozen_string_literal: true

require './text'
require './game_tools'
require './computer'
require './player'

# Mastermind
class Mastermind
  include Text
  include GameTools

  attr_accessor :guess, :breaker, :maker
  attr_reader :turns, :hints, :mode

  def initialize
    @code = ''
    @guess = ''
    @mode = ''
    @hints = ''
    @turns = 1
  end

  def assign_roles
    if @mode == 'b'
      @breaker = Player.new(self)
      @maker = Computer.new(self)
    else
      @breaker = Computer.new(self)
      @maker = Player.new(self)
    end
  end

  def game_init
    @mode = choose_mode
    assign_roles
    @code = @maker.create_code
    puts "\n#{ask(:guess)}\n\n"
  end

  def game
    game_init

    while @turns <= TURNS
      puts "Turn #{@turns}"

      @breaker.play
      @hints = hint(@guess, @code)
      puts "Clues: #{@hints}\n\n"

      break if compare?(@guess, @code)

      @turns += 1
    end
  end

  def play
    game

    if compare?(@guess, @code)
      puts end_msg(:win)
    else
      puts end_msg(:lose)
    end
  end
end

game = Mastermind.new

game.play
