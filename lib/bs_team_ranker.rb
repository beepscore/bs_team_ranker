#!/usr/bin/env ruby

require 'pp'
require_relative 'bs_optparse'
require_relative 'bs_file_accessor'
require_relative 'league_controller'

# parse! alters its argument, see method description for details
options = BsTeamRanker::BsOptparse.parse!(ARGV)
pp options
pp ARGV

file_accessor = BsTeamRanker::BsFileAccessor.new
league_controller = BsTeamRanker::LeagueController.new
ARGV.each do |infile|
  puts "Adding games #{infile}"
  games_string = file_accessor.string_from_file(infile, 'utf-8')
  league_controller.add_games(games_string)
end

ranked_teams = league_controller.ranked_teams(league_controller.teams)
ranked_string = league_controller.ranked_teams_string(ranked_teams)
puts ranked_string

file_accessor.write(ranked_string, options.output_file_name)
