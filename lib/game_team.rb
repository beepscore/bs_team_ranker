#!/usr/bin/env ruby

# GameTeam is a lightweight team for use by Game
class GameTeam

  attr_reader   :name
  attr_accessor :score

  def initialize(name)
    @name = name
    @score = 0
  end

end
