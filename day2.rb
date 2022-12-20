# frozen_string_literal: true

class StrategyGuide
  attr_reader :rounds

  def initialize(rounds)
    @rounds = rounds
  end

  def total_score
    rounds.sum(&:score)
  end
end

class Round
  def initialize(opponnents_shape, your_shape)
    @opponnents_shape = opponnents_shape
    @your_shape = your_shape
  end

  def outcome
    if @opponnents_shape == @your_shape
      Draw
    elsif @opponnents_shape > @your_shape
      Lose
    else
      Win
    end
  end

  def score
    outcome.score + @your_shape.score
  end
end

class Outcome
  def self.score
    self::SCORE
  end
end

class Draw < Outcome
  SCORE = 3
end

class Lose < Outcome
  SCORE = 0
end

class Win < Outcome
  SCORE = 6
end

class Shape
  include Comparable

  def self.build_from(character)
    # TODO: Do this in a better way
    case character
    when "A"
      Rock.new
    when "X"
      Rock.new
    when "B"
      Paper.new
    when "Y"
      Paper.new
    when "C"
      Scissors.new
    when "Z"
      Scissors.new
    else
      raise ArgumentError("Character not supported to build shapes from")
    end
  end

  def score
    self.class::SCORE
  end

  def <=>(other)
    0 if other.class == self.class
  end
end

class Rock < Shape
  SCORE = 1

  def <=>(other)
    if other.class == Paper
      -1
    elsif other.class == Scissors
      1
    else
      super(other)
    end
  end
end

class Paper < Shape
  SCORE = 2

  def <=>(other)
    if other.class == Scissors
      -1
    elsif other.class == Rock
      1
    else
      super(other)
    end
  end
end

class Scissors < Shape
  SCORE = 3

  def <=>(other)
    if other.class == Rock
      -1
    elsif other.class == Paper
      1
    else
      super(other)
    end
  end
end

rounds = (File.readlines 'day2_puzzle_input.txt').map do |line| 
  opponents_character, your_character = line.split
  opponents_shape = Shape.build_from(opponents_character)
  your_shape = Shape.build_from(your_character)
  Round.new(opponents_shape, your_shape)
end
guide = StrategyGuide.new(rounds)

puts "Part 1: #{guide.total_score}"

