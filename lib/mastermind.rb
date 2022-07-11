# frozen_string_literal: true

require './text'

# Mastermind
class Mastermind
  include Text

  TURNS = 5
  COLORS = 6
  PEGS = 4

  def initialize
    @code = ''
    @guess = ''
    @hints = []
    @mode = ''
  end

  def computer_code
    @code = []
    PEGS.times { @code << rand(1..COLORS) }
    @code = @code.join.to_s
  end

  def to_sym(arr)
    result = []
    arr[0].times { result << 'X' }
    arr[1].times { result << 'O' }
    result.join
  end

  def check(code)
    code.match?(/^[1-6]{4}$/)
  end

  def check_mode
    %w[b m].include?(@mode)
  end

  def input_code
    code = ''
    until check(code)
      code = gets.chomp
      quit(code)
      puts wrong_format(:code) unless check(code)
    end
    code
  end

  def quit(input)
    return unless input == 'q'

    response = ''
    until %w[y n].include?(response)
      puts quit_msg
      response = gets.chomp

      abort 'BYE:)' if response == 'y'
    end

    puts in_the_game
  end

  def hint(guess, code)
    hints = []
    ignore = []

    hints << guess.zip(code).count do |x|
      if x.inject(:eql?)
        ignore << x[0]
        true
      end
    end

    hints << (guess.uniq - ignore).count { |x| code.include?(x) }
    hints
  end

  def choose_mode
    puts ask(:mode)
    until check_mode
      @mode = gets.chomp
      puts wrong_format(:mode) unless check_mode
    end
  end

  def game_type
    @mode == 'b' ? @guess = input_code : computer_game
  end

  def start
    choose_mode

    if @mode == 'b'
      computer_code
    else
      puts enter_code
      @code = input_code
    end
  end

  def game
    start
    p @code
    TURNS.times do |i|
      puts "Turn #{i + 1}"
      ask(:guess)
      game_type
      @hints = hint(@guess.to_i.digits, @code.to_i.digits)
      puts "CLues: #{to_sym(@hints)}\n\n"

      break if compare_code

      @guess = ''
    end
  end

  def computer_game; end

  def play
    game

    if compare_code
      puts end_msg(:win)
    else
      puts end_msg(:lose)
    end
  end

  private

  def compare_code
    @guess == @code
  end
end

game = Mastermind.new

game.play
