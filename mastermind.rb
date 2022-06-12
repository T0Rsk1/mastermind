# frozen_string_literal: true

# Mastermind
class Mastermind
  TURNS = 12
  COLORS = 6
  PEGS = 4

  attr_reader :code, :guess

  def initialize
    @code = []
    @guess = []
  end

  def mk_code
    PEGS.times { @code << rand(1..COLORS) }
  end

  def input_guess
    gets.chomp.to_i.digits.reverse
  end

  def ask_guess
    puts 'Give me your best shot! Choose 4 numbers between 1 and 6.'
  end

  def check_guess
    return true if @guess.size == 4 && @guess.all? { |x| x <= 6 && x.positive? }

    false
  end

  def wrong_format
    puts 'Try again. Choose 4 numbers between 1 and 6.'
  end

  def end_msg(compare)
    if compare
      puts 'You win! You sly dog!'
    else
      puts 'Time is up. You suck.'
    end
  end

  def retrieve_guess
    ask_guess
    until check_guess
      @guess = input_guess
      wrong_format unless check_guess
    end
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
    to_sym(hints)
  end

  def to_sym(arr)
    result = []
    arr[0].times { result << 'X' }
    arr[1].times { result << 'O' }
    result
  end

  def compare_code
    @guess == @code
  end

  def user_input
    count = 0

    TURNS.times do
      puts "Turn #{count += 1}"
      retrieve_guess
      p hint

      break if compare_code

      @guess = []
    end
  end

  def play
    mk_code
    # p @code
    user_input
    end_msg(compare_code)
  end
end

Mastermind.new.play
