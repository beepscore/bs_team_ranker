#!/usr/bin/env ruby

module BSTeamRanker
  class BSFileAccessor

    attr_reader :file_encoding
    attr_reader :file_name

    def initialize
    end

    # read a file and return a string
    def string_from_file(file_name, external_encoding)
      @file_name = file_name

      # ruby 1.9.3 and ruby 2.0 default_external encoding is UTF-8
      # You can see this from irb
      # $ irb
      # irb(main):001:0> Encoding.default_external
      # => <Encoding:UTF-8>

      # https://www.ruby-lang.org/en/news/2013/02/24/ruby-2-0-0-p0-is-released/
      # default internal_encoding is nil. set it.
      internal_encoding = "utf-8"
      if (external_encoding == internal_encoding)
        # avoid ruby warning:
        # Ignoring internal encoding utf-8: it is identical to external encoding utf-8
        read_access_and_encoding = "r"
      else
        read_access_and_encoding = "r:#{external_encoding}:#{internal_encoding}"
      end

      file_string = ""
      # at end of block, file will be closed automatically
      File.open(@file_name, read_access_and_encoding) do |file|

        @file_encoding = file.external_encoding

        file.each_line do |line|
          file_string += line
        end
      end

      file_string
    end

    def write(a_string, to_file)
      # References
      # Learn Ruby the Hard Way ex20.rb
      # http://stackoverflow.com/questions/4795447/rubys-file-open-and-the-need-for-f-close

      output = File.open(to_file, 'w')
      output.write(a_string)
      output.close()
      puts "Wrote to file #{to_file}"
    end

  end
end

