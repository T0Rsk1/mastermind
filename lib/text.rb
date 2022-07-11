# frozen_string_literal: true

# Text
module Text
  def ask(query)
    {
      guess: 'Give me your best shot! Choose 4 numbers between 1 and 6.',
      mode: 'Do you want to be the codebreaker(b) or the codemaker(m)? (b,m)'
    }[query]
  end

  def wrong_format(input)
    {
      code: 'Try again. Choose 4 numbers between 1 and 6.',
      mode: 'Try again! Type b or m.'
    }[input]
  end

  def end_msg(msg)
    {
      win: 'You win! You sly dog!',
      lose: "Time is up. You suck.\nCode was #{@code}"
    }[msg]
  end

  def quit_msg
    'Are you sure you want to quit?(y/n)'
  end

  def in_the_game
    'Still in the game I see!'
  end

  def enter_code
    'Enter a 4 digit secret code using numbers 1-6: '
  end
end
