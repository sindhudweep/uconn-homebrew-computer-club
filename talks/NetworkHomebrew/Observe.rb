#!/usr/bin/ruby
#  Copyright 2008 Sindhudweep N. Sarkar, Christopher M. Forte
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
require 'webrick/httpproxy'

class TProxy < WEBrick::HTTPProxyServer
  def initialize (*args)
    super(*args)
    config.merge!(
    :RequestCallback => method( :request_logger))
  end
  
  def request_logger (req, res)
      puts "-"*80
      puts req.request_line, req.raw_header
      puts "-"*80
  end
  
end

p = TProxy.new( :Port => 8010)
trap("INT"){p.stop}
p.start
