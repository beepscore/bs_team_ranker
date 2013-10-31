#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

module BsTeamRanker
  # Rank teams
  class BsOptparse

    OUTPUT_FILE_NAME_DEFAULT = '../ranks.txt'

    # Return a structure describing the options.
    # Alters an_args. Consumes options and parameters from an_args, leaves remaining args
    # References
    # http://www.ruby-doc.org/stdlib-2.0.0/libdoc/optparse/rdoc/OptionParser.html#documentation
    # http://ruby.about.com/od/advancedruby/a/optionparser.htm
    #
    def self.parse!(an_args)
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      options = OpenStruct.new
      options.output_file_name = OUTPUT_FILE_NAME_DEFAULT

      opt_parser = OptionParser.new do |opts|
        opts.banner = <<-END
Usage:
  bs_team_ranker.rb [options] input_file_name1 input_file_name2...
Example:
  bs_team_ranker.rb -o my_ranks.txt games1.txt games2.txt games3.txt
        END

        opts.separator ""
        opts.separator "Options:"

        # Optional argument, uses delimiter []
        opts.on("-o [OUTPUT_FILE_NAME]", "--outfile [OUTPUT_FILE_NAME]",
                "Default #{OUTPUT_FILE_NAME_DEFAULT}") do |output_file|
          options.output_file_name = output_file
        end

        # No argument
        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        opts.separator ""
        opts.separator "Input file format:"
        opts.separator <<-END
  File may be utf-8 with accented characters or us-ascii.
  One game per line.
  On each line, each team score must be followed by a comma, except no comma at end of line.
  <team_name> <score>, <team_name> <score>
  Honey Badgers 6, Rhinos 3
  Atlético Madrid 4, Équipe de France 2
  Bigfeet 2, Little Feet 2

  On each line, order does not matter. Typically the winning team is listed first.
  Bigfeet 0, Little Feet 7

  For sports other than soccer, a game such as a swim meet may have more than two teams.
  <team_name> <score>, <team_name> <score>, <team_name> <score>
  USA swimming 32, Australia 30, Rubber Duckies 7
        END

      end

      # parse! consumes options and parameters from an_args, leaves remaining args
      opt_parser.parse!(an_args)
      options
    end  # parse

  end  # class
end  # module
