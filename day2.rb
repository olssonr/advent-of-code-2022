# frozen_string_literal: true
require 'pry'
require 'pry-byebug'

class Round
  def initialize(opponents_shape, your_shape, outcome: nil)
    @opponents_shape = opponents_shape
    @your_shape = your_shape
    @outcome = outcome
  end

  def outcome
    @outcome || determine_outcome(@opponents_shape, @your_shape)
  end

  def determine_outcome(opponents_shape, your_shape)
    if opponents_shape == your_shape
      Draw
    elsif opponents_shape > your_shape
      Lose
    else
      Win
    end
  end

  def your_shape
    @your_shape || determine_your_shape_from_outcome
  end

  # TODO: Convenient to not have to define this logic again, but
  # not very efficient to do this for all cases.
  # Perhaps could build a map once and then just lookup?
  def determine_your_shape_from_outcome
    StrategyGuide::SHAPES.map(&:new).select { |shape| determine_outcome(@opponents_shape, shape) == @outcome }.first
  end

  def score
    outcome.score + your_shape.score
  end
end

class Outcome
  def self.score
    self::SCORE
  end

  def self.build_from(character)
    case character
    when "X"
      Lose
    when "Y"
      Draw
    when "Z"
      Win
    else
      raise ArgumentError("Character not supported to build outcomes from")
    end
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

class StrategyGuide
  attr_reader :rounds

  SHAPES = [Rock, Paper, Scissors]

  def initialize(rounds)
    @rounds = rounds
  end

  def total_score
    rounds.sum(&:score)
  end
end

rounds = (File.readlines 'day2_puzzle_input.txt').map do |line| 
  opponents_character, your_character = line.split
  opponents_shape = Shape.build_from(opponents_character)
  your_shape = Shape.build_from(your_character)
  Round.new(opponents_shape, your_shape)
end
missunderstood_guide = StrategyGuide.new(rounds)

puts "Part 1: #{missunderstood_guide.total_score}"

rounds = (File.readlines 'day2_puzzle_input.txt').map do |line| 
  opponents_character, outcome_character = line.split
  opponents_shape = Shape.build_from(opponents_character)
  wanted_outcome = Outcome.build_from(outcome_character)
  Round.new(opponents_shape, nil, outcome: wanted_outcome)
end
guide = StrategyGuide.new(rounds)

puts "Part 2: #{guide.total_score}"