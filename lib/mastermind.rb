# frozen_string_literal: true

require './text'

# Mastermind
class Mastermind
  include Text

  TURNS = 12
  COLORS = '6'
  PEGS = 4

  def initialize
    @code = ''
    @guess = ''
    @mode = ''
    @hints = ''
    @code_list = ('1'..COLORS).to_a.repeated_permutation(PEGS).to_a.map(&:join)
  end

  def choose_mode
    puts ask(:mode)
    until check_mode?
      @mode = gets.chomp
      puts wrong_format(:mode) unless check_mode?
    end
  end

  def create_code
    if @mode == 'b'
      random_code
    else
      puts enter_code
      @code = input_code
    end
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

  def input_code
    @guess = ''
    code = ''
    until check_code?(code)
      code = gets.chomp
      quit(code)
      puts wrong_format(:code) unless check_code?(code)
    end
    code
  end

  def computer_game; end

  def play
    game

    if compare_code?
      puts end_msg(:win)
    else
      puts end_msg(:lose)
    end
  end

  # private

  def check_mode?
    %w[b m].include?(@mode)
  end

  def check_code?(code)
    code.match?(/^[1-#{COLORS}]{#{PEGS}}$/)
  end

  def compare_code?
    @guess == @code
  end

  def random_code
    PEGS.times { @code += ('1'..COLORS).to_a.sample }
  end

  def game_type
    @mode == 'b' ? @guess = input_code : computer_game
  end

  def hint(guess, code)
    hints = ''

    guess.zip(code).each do |x|
      if x.inject(:eql?)
        guess.delete(x[0])
        hints += 'B'
      end
    end

    guess.uniq.each { |x| hints += 'W' if code.include?(x) }
    hints
  end

  def game
    choose_mode
    create_code

    TURNS.times do |i|
      puts "Turn #{i + 1}"
      ask(:guess)
      game_type
      @hints = hint(@guess.to_i.digits, @code.to_i.digits)
      puts "CLues: #{@hints}\n\n"

      break if compare_code?
    end
  end
end

game = Mastermind.new

game.play
