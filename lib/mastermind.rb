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
    @turns = 1
    @possible_guesses = {}
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

  def computer_game
    if @turns == 1
      @guess = '1122'
      @possible_guesses = possible_next_guess_list([@guess])
    else
      reduce_code_list
      @guess = choose_next_guess
    end
    sleep(1.5)
  end

  def reduce_code_list
    @code_list = @possible_guesses[@guess][@hints]
    @possible_guesses = possible_next_guess_list
  end

  def possible_answer_list(guess)
    possible_answers = {}

    @code_list.each do |code|
      hints = hint(guess, code)
      if possible_answers.include?(hints)
        possible_answers[hints] << code
      else
        possible_answers[hints] = [code]
      end
    end

    possible_answers
  end

  def possible_next_guess_list(code_list = @code_list)
    possible_guess = {}

    code_list.each { |code| possible_guess[code] = possible_answer_list(code) }

    possible_guess
  end

  def guess_score(guesses)
    scores = {}
    max = 0

    guesses.each do |guess, hints|
      hints.each_value { |response| max = response.size if response.size > max }
      scores[guess] = max
      max = 0
    end

    scores
  end

  def choose_next_guess
    next_guess = ''
    scores = guess_score(@possible_guesses)
    min = scores.values[0]

    scores.each do |guess, score|
      if score < min
        min = score
        next_guess = guess
      end
    end

    next_guess = @code_list[0] if next_guess.empty?
    next_guess
  end

  def hint(guess, code)
    hints = ''
    guess = guess.chars
    code = code.chars

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

    while @turns <= TURNS
      puts "Turn #{@turns}"
      ask(:guess)
      game_type
      @hints = hint(@guess, @code)
      puts "Guess: #{@guess}"
      puts "Clues: #{@hints}\n\n"

      break if compare_code?

      @turns += 1
    end
  end
end

game = Mastermind.new

game.play
