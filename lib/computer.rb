# frozen_string_literal: true

require './game_tools'

# Computer
class Computer
  include GameTools

  def initialize(game)
    @game = game
    @possible_guesses = {}
    @code_list = ('1'..Mastermind::COLORS).to_a.repeated_permutation(Mastermind::PEGS).to_a.map(&:join)
  end

  def reduce_code_list
    @code_list = @possible_guesses[@game.guess][@game.hints]
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

  def create_code
    random_code
  end

  def play
    sleep(1.5)
    if @game.turns == 1
      @game.guess = random_code
      @possible_guesses = possible_next_guess_list([@game.guess])
    else
      reduce_code_list
      @game.guess = choose_next_guess
    end
    puts "Guess: #{@game.guess}"
  end
end
