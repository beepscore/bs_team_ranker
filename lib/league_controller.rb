#!/usr/bin/env ruby

require_relative 'game'

class LeagueController

  attr_reader :games
  attr_accessor :teams

  def initialize()

    @games = []
    @teams = []

  end

  def add_games(a_games_string)
    a_games_string.each_line do |line|
      # add game
      # use chomp to remove line ending (platform independent \n, \r)
      game = Game.new(line.chomp)
      @games.push(game)
    end
  end

  # private API. Exposed for use by unit tests
  def team_name_in_teams? (a_teams, a_team_name)
    a_teams.any?{|team| team.name == a_team_name}
  end

  # private API. Exposed for use by unit tests
  # add team(s) to @teams if a_game involves one or more unknown teams
  def add_teams(a_game)
    a_game.game_teams.each do |game_team|
      unless team_name_in_teams?(@teams, game_team.name)
        team = Team.new(game_team.name)
        @teams.push(team)
      end
    end
  end

  # team instances matching a_game game_team instances
  def teams_in_game(a_game)
    teams_in_game = []
    a_game.game_teams.each do |game_team|
      team_in_game = @teams.find_all{|team| game_team.name == team.name}.first
      teams_in_game.push(team_in_game)
    end
    teams_in_game
  end

  def teams_with_score_max(a_game)
    teams_with_score_max = []
    game_teams_with_score_max = a_game.teams_with_score_max(a_game.game_teams)
    game_teams_with_score_max.each do |game_team_with_score_max|
      # find team instance matching game_team instance
      team_with_score_max = @teams.find{|team| team.name == game_team_with_score_max.name}
      teams_with_score_max.push(team_with_score_max)
    end
    teams_with_score_max
  end

  def update_teams(a_game)

    add_teams(a_game)

    teams_in_game = teams_in_game(a_game)
    teams_with_score_max = teams_with_score_max(a_game)

    teams_in_game.each do |team_in_game|

      # update won, tied, lost for each team in this game
      if !teams_with_score_max.include?(team_in_game)
        # team isn't in group with high score
        team_in_game.lost += 1

      else
        # team is in group with high score.
        # team won or tied
        if (1 == teams_with_score_max.length)
          # only one team has high score
          # team won
          team_in_game.won += 1
        elsif (2 <= teams_with_score_max.length)
          # more than one team has high score
          # team tied
          team_in_game.tied += 1
        end
      end
    end
  end

end
