#!/usr/bin/env ruby

class Game

  # game has 2 teams, so don't bother to make a teams collection
  attr_reader :team_a
  attr_reader :team_b
  attr_reader :team_a_score
  attr_reader :team_b_score

  def initialize(game_string)
    team_a_string = game_string.split(',')[0].strip()
    team_b_string = game_string.split(',')[1].strip()

    @team_a = name(team_a_string)
    @team_b = name(team_b_string)
  end

  def name(team_string)
    # delete score. match one or more whitespace followed by one or more digits followed by end of line
    team_string.gsub(/\s+\d+$/, '')
  end

end
