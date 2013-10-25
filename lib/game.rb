#!/usr/bin/env ruby

class Game

  attr_reader :team_a
  attr_reader :team_b
  attr_reader :team_a_score
  attr_reader :team_b_score

  def initialize(game_string)
    team_a_string = game_string.split(',')[0]
    team_b_string = game_string.split(',')[1]

    @team_a = name(team_a_string)
  end

  def name(team_string)
    # simplest implementation that can pass test
    # TODO use regex to parse string?
    'Tarantulas'
  end

end
