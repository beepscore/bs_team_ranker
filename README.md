# Purpose
Describe how to install and use bs_team_ranker.

# References
This is a solution to a coding exercise.
For more info see problem-statement.md

<http://bundler.io>

# Requirements
bundler
see Gemfile, bs_team_ranker.gemspec

# Installation Instructions

## Get code
e.g. Clone git repository from github.

## Install gem dependencies
The app uses bundler to specify its dependency gem versions.

    $ cd <path>/bs_team_ranker
    $ bundle install --deployment

## To run tests
    $ cd <path>/bs_team_ranker
    $ bundle exec rake

## To run app

### See command line help for further instructions
    $ cd <path>/bs_team_ranker
    $ bundle exec bs_team_ranker -h

---

# Appendices

## Troubleshooting

### If app doesn't run
Set file permission executable.
Probably this step will not be necessary.

    $ cd <path>/bs_team_ranker/bin
    $ chmod u+x bs_team_ranker

### If load path isn't configured correctly
As a workaround, can use ruby -I lib:

    $ cd <path>/bs_team_ranker
    $ bundle exec ruby -I lib bin/bs_team_ranker -h

## Package app as a gem
The app may be packaged as a gem and published.

    $ bundle package

See bundle.io for more info.
