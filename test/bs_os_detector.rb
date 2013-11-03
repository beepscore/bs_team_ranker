#!/usr/bin/env ruby

require 'rbconfig'

# http://stackoverflow.com/questions/11784109/detecting-operating-systems-in-ruby
#
class BsOsDetector

  def self.os
    # ||= assigns value if one isn't already set. If lhs is false or nil, sets it to rhs.
    # http://stackoverflow.com/questions/1389081/what-does-the-operator-stands-for-in-ruby#1389101
    @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        :unknown
      end
    )
  end

end
