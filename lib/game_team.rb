#!/usr/bin/env ruby

# GameTeam is a lightweight team for use by Game
class GameTeam

  attr_reader :name
  attr_reader :score

  def initialize(a_team_string)
    unless a_team_string.nil?
      @name = name_from_team_string(a_team_string)
      @score = score_from_team_string(a_team_string)
    end
  end

  # private API. Exposed for use by unit tests
  def name_from_team_string(a_team_string)
    name = nil
    unless a_team_string.nil?
      # delete score. match one or more whitespace followed by one or more digits followed by end of line
      name = a_team_string.gsub(/\s+\d+$/, '')
    end
    name
  end

  # private API. Exposed for use by unit tests
  def score_from_team_string(a_team_string)
    score = nil
    unless a_team_string.nil?
      # match one or more digits followed by end of line
      re = /\d+$/
      match_data = a_team_string.match re
      unless match_data.nil?
        score = match_data[0].to_i
      end
    end
    score
  end

end
