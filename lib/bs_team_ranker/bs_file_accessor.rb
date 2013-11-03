#!/usr/bin/env ruby

module BsTeamRanker
  class BsFileAccessor

    attr_reader :file_encoding
    attr_reader :file_name

    def initialize
    end

    # read a file and return a string
    # param an_external_encoding. If nil use default external encoding
    #
    # |os      |  default_external encoding |
    # |------- | -------------------------- |
    # |macosx  |  UTF-8                     |
    # |windows |  IBM437                    |
    # You can see this from irb
    # $ irb
    # irb(main):001:0> Encoding.default_external
    # => <Encoding:UTF-8>
    # http://www.ruby-doc.org/core-2.0.0/IO.html#method-c-new
    # http://www.ruby-doc.org/core-2.0.0/Encoding.html
    #
    def string_from_file(file_name, an_external_encoding)
      @file_name = file_name

      file = nil
      if (an_external_encoding.nil?)
        # don't specify external encoding, just use default
        file = File.open(@file_name, 'r')
      else
        file = File.open(@file_name, "r:#{an_external_encoding}")
      end

      @file_encoding = file.external_encoding

      file_string = ""
      file.each_line do |line|
        file_string += line
      end
      file.close

      file_string
    end

    def write(a_string, to_file)
      # References
      # Learn Ruby the Hard Way ex20.rb
      # http://stackoverflow.com/questions/4795447/rubys-file-open-and-the-need-for-f-close

      output = File.open(to_file, 'w')
      output.write(a_string)
      output.close
      puts "Wrote to file #{to_file}"
    end

  end
end

