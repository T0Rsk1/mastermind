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
    puts 'Give me your best shot. Choose 4 numbers between 1 and 6.'
  end

  def check_guess
    return true if @guess.size == 4 && @guess.all? { |x| x <= 6 }

    false
  end

  def wrong_format
    puts 'Try again. Choose 4 numbers between 1 and 6.'
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
      else false
      end
    end

    hints << (@guess.uniq - ignore).count { |x| @code.include?(x) }
  end
end
