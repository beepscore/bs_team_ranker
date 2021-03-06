#!/usr/bin/env ruby

require_relative 'game_team'

module BsTeamRanker
  class Game

    # Use a collection in order to follow DRY principle
    # In soccer a game has 2 teams
    # In some sports such as swimming, an 'game' could be a swim meet and contain more than 2 teams
    attr_reader :game_teams

    def initialize(a_game_string)
      @game_teams = []
      unless a_game_string.nil?
        team_strings = a_game_string.split(',')
        # strip leading and trailing whitespace. This is platform independent
        team_strings.map! {|game_string| game_string.strip}
        team_strings.each do |team_string|
          game_team = GameTeam.new(team_string)
          @game_teams.push(game_team)
        end
      end
    end

    def scores(a_game_teams)
      a_game_teams.map{|game_team| game_team.score}
    end

    def score_max(a_game_teams)
      scores(a_game_teams).max
    end

    def teams_with_score(a_game_teams, a_score)
      a_game_teams.find_all{|game_team| a_score == game_team.score}
    end

    def teams_with_score_max(a_game_teams)
      teams_with_score(a_game_teams, score_max(a_game_teams))
    end

  end
end
