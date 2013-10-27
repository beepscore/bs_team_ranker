#!/usr/bin/env ruby

class BSFileAccessor

  attr_reader :file_encoding
  attr_reader :file_name
  attr_reader :file_string

  def initialize(file_name, external_encoding)
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

    # at end of block, file will be closed automatically
    File.open(@file_name, read_access_and_encoding) do |file|

      @file_encoding = file.external_encoding

      @file_string = ""
      file.each_line do |line|
        @file_string += line
      end
    end

  end

end
