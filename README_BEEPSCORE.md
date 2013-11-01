# Purpose
Describe how to install and use bs_team_ranker.

# References
<http://bundler.io>

# Requirements
Ruby 2.0.0
bundler (~> 1.3)

# Installation Instructions
The app uses bundler to specify it's dependency gem versions.
The app is structured as a gem.

## Clone repo from github.
    $ cd <path>/bs_team_ranker

## To generate a gem
I made a gem locally but didn't publish it.
Publishing could be an easier way to share the code.

    $ bundle package

## To install gems
    $ bundle install --deployment

## set file permission executable
    $ cd <path>/bs_team_ranker/bin
    $ chmod u+x bs_team_ranker

## To run tests
    $ cd <path>/bs_team_ranker
    $ bundle exec rake

## To run app
Help gives further instructions.
### If gem is installed:
    $ cd <path>/bs_team_ranker
    $ bundle exec bin/bs_team_ranker -h

### If gem is not installed, must use ruby -I lib:
    $ cd <path>/bs_team_ranker
    $ bundle exec ruby -I lib bin/bs_team_ranker -h

