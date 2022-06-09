class Mastermind
  TURNS = 12.freeze
  COLORS = 6.freeze
  PEGS = 4.freeze

  attr_reader :code

  def initialize
    @code = []
  end

  def mk_code
    PEGS.times { @code << rand(1..COLORS) }
  end

  

end

game = Mastermind.new
game.mk_code
print game.code