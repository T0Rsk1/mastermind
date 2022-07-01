# frozen_string_literal: true

require './text'

# Mastermind
class Mastermind
  include Text

  TURNS = 12
  COLORS = 6
  PEGS = 4

  def initialize
    @code = []
    @guess = []
    @hints = []
    @mode = ''
  end

  def computer_code
    PEGS.times { @code << rand(1..COLORS) }
  end

  def to_sym(arr)
    result = []
    arr[0].times { result << 'X' }
    arr[1].times { result << 'O' }
    result.join
  end

  def compare_code
    @guess == @code
  end

  def check(input)
    input.size == 4 && input.all? { |x| x <= 6 && x.positive? }
  end

  def check_mode
    %w[b m].include?(@mode)
  end

  def player_guess
    until check(@guess)
      @guess = gets.chomp
      quit
      @guess = @guess.to_i.digits.reverse
      puts wrong_format(:code) unless check(@guess)
    end
  end

  def player_code
    until check(@code)
      @code = gets.chomp.to_i.digits.reverse
      puts wrong_format(:code) unless check(@code)
    end
  end

  def quit
    return unless @guess == 'q'

    response = ''
    until %w[y n].include?(response)
      puts quit_msg
      response = gets.chomp

      abort 'BYE:)' if response == 'y'
    end

    puts in_the_game
  end

  def hint
    @hints = []
    ignore = []

    @hints << @guess.zip(@code).count do |x|
      if x.inject(:eql?)
        ignore << x[0]
        true
      end
    end

    @hints << (@guess.uniq - ignore).count { |x| @code.include?(x) }
    puts "CLues: #{to_sym(@hints)}\n\n"
  end

  def choose_mode
    puts ask_mode
    until check_mode
      @mode = gets.chomp
      puts wrong_format(:mode) unless check_mode
    end
  end

  def player_game
    player_guess
  end

  def computer_game
    computer_guess
  end

  def game_type
    @mode == 'b' ? player_game : computer_game
  end

  def start
    choose_mode

    if @mode == 'b'
      computer_code
    else
      puts enter_code
      player_code
    end
  end

  def game
    start

    TURNS.times do |i|
      puts "Turn #{i + 1}"
      ask_guess
      game_type
      hint

      break if compare_code

      @guess = []
    end
  end

  def computer_guess; end

  def play
    game
    puts end_msg
  end
end

Mastermind.new.play
