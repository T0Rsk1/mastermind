# frozen_string_literal:true

# Game
module GameTools
  TURNS = 12
  COLORS = '6'
  PEGS = 4

  def check_code?(code)
    code.match?(/^[1-#{COLORS}]{#{PEGS}}$/)
  end

  def input_code(mode)
    code = ''

    until check_code?(code)
      print mode == 'b' ? 'Guess: ' : 'Code: '
      code = gets.chomp
      quit(code)
      puts wrong_format(:code) unless check_code?(code)
    end

    code
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

  def random_code
    code = ''
    PEGS.times { code += ('1'..COLORS).to_a.sample }
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

  def check_mode?(mode)
    %w[b m].include?(mode)
  end

  def compare?(guess, code)
    guess == code
  end

  def choose_mode
    mode = ''
    puts ask(:mode)
    until check_mode?(mode)
      mode = gets.chomp
      puts wrong_format(:mode) unless check_mode?(mode)
    end
    mode
  end
end
