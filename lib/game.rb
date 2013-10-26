#!/usr/bin/env ruby

class Game

  # game has 2 teams, so don't bother to make a teams collection
  attr_reader :team_a
  attr_reader :team_b
  attr_reader :team_a_score
  attr_reader :team_b_score

  def initialize(game_string)
    unless game_string.nil?
      team_a_string = game_string.split(',')[0].strip()
      team_b_string = game_string.split(',')[1].strip()

      @team_a = name(team_a_string)
      @team_b = name(team_b_string)

      @team_a_score = score(team_a_string)
      @team_b_score = score(team_b_string)
    end
  end

  def name(team_string)
    name = nil
    unless team_string.nil?
      # delete score. match one or more whitespace followed by one or more digits followed by end of line
      name = team_string.gsub(/\s+\d+$/, '')
    end
    name
  end

  def score(team_string)
    score = nil
    unless team_string.nil?
      # match one or more digits followed by end of line
      re = /\d+$/
      match_data = team_string.match re
      unless match_data.nil?
        score = match_data[0].to_i
      end
    end
    score
  end

end
