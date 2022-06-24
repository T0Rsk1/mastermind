# frozen_string_literal: true

# Text
module Text
  def ask_guess
    puts 'Give me your best shot! Choose 4 numbers between 1 and 6.'
  end

  def wrong_format
    puts 'Try again. Choose 4 numbers between 1 and 6.'
  end

  def end_msg(compare, code)
    if compare
      puts 'You win! You sly dog!'
    else
      puts 'Time is up. You suck.'
      puts "Code was #{code.join}"
    end
  end
end
