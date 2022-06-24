# frozen_string_literal: true

require './text'

# Mastermind
class Mastermind
  include Text

  TURNS = 12
  COLORS = 6
  PEGS = 4

  # attr_reader :code, :guess

  def initialize
    @code = []
    @guess = []
  end

  def mk_code
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

  def check_guess
    return true if @guess.size == 4 && @guess.all? { |x| x <= 6 && x.positive? }

    false
  end

  def input_guess
    ask_guess
    until check_guess
      @guess = gets.chomp
      quit
      @guess = @guess.to_i.digits.reverse
      wrong_format unless check_guess
    end
  end

  def quit
    return unless @guess.include?('q')

    answer = %w[y n]
    response = ''
    until answer.include?(response)
      puts 'Are you sure you want to quit?(y/n)'

      response = gets.chomp

      abort 'BYE:)' if response == 'y'
    end
    puts 'Still in the game I see!'
  end

  def hint
    hints = []
    ignore = []

    hints << @guess.zip(@code).count do |x|
      if x.inject(:eql?)
        ignore << x[0]
        true
      end
    end

    hints << (@guess.uniq - ignore).count { |x| @code.include?(x) }
    puts "CLues: #{to_sym(hints)}\n\n"
  end

  def game
    count = 0

    TURNS.times do
      puts "Turn #{count += 1}"
      input_guess
      hint

      break if compare_code

      @guess = []
    end
  end

  def play
    mk_code
    game
    end_msg(compare_code, @code)
  end
end

Mastermind.new.play
