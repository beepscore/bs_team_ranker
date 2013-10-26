#!/usr/bin/env ruby

class Team

  attr_reader   :name
  # number of games won, tied, lost
  attr_accessor :won, :tied, :lost

  def initialize(name)
    @name = name
    @won = 0
    @tied = 0
    @lost = 0
  end

  def points
    (3 * won) + tied
  end

end
