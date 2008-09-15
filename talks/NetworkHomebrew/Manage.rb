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

#  You'll need to use sudo if you're testing this on a modern debian like
#  distro. eth0 is our wan interface, eth1 is our lan interface.
#  Edit this file as needed.

set :scm, :git
set :repository, "git://github.com/sindhudweep/uconn-homebrew-computer-club.git"

namespace :wrt54g do

  desc "Purge firewall rules."
  task :purge_firewall_rules do
    ["iptables -F",
    "iptables -X",
    "iptables -t nat -F",
    "iptables -t nat -X",
    "iptables -t mangle -F",
    "iptables -t mangle -X"].each {|cmd| run cmd}
  end
  
  desc "Enable non-permissive default firewall rules."
  task :make_non_permissive do
    ["iptables -P INPUT DROP",
    "iptables -P OUTPUT ACCEPT"].each {|cmd| run cmd}
  end
  
  desc "Enable IPv4 Forwarding"
  task :enable_ip4_forwarding do
    run "echo 1 > /proc/sys/net/ipv4/ip_forward"
    run "for f in /proc/sys/net/ipv4/conf/*/rp_filter ; do echo 1 > $f ; done"
  end
  
  desc "Only do explicit Forwarding"
  task :explicit_forwarding_only do
    ["iptables -P INPUT ACCEPT"
    "iptables -P OUTPUT ACCEPT",
    "iptables -P FORWARD DROP"].each {|cmd| run cmd}
  end
  
  desc "Vanilla NAT"
  task :enable_vanilla_nat do
    ["iptables -I FORWARD -i eth1 -d 192.168.0.0/255.255.0.0 -j DROP",
    "iptables -A FORWARD -i eth1 -s 192.168.0.0/255.255.0.0 -j ACCEPT",
    "iptables -A FORWARD -i eth0 -d 192.168.0.0/255.255.0.0 -j ACCEPT",
    "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE"].each {|cmd| run cmd}
  end
  
  desc "Transparent Proxying NAT"
  task :enable_crazy_nat do
    ["iptables -t nat -A PREROUTING -i eth1 -s ! 192.168.1.10 -p tcp --dport 80 -j DNAT --to 192.168.1.10:8010",
    "iptables -t nat -A POSTROUTING -o eth1 -s 192.168.0.0/16 -d 192.168.1.10 -j SNAT --to 192.168.1.1",
    "iptables -A FORWARD -s 192.168.0.0/16 -d 192.168.1.10 -i eth1 -o eth1 -p tcp --dport 8010 -j ACCEPT"].each {|cmd| run cmd}
  end
    
  desc "Base Mode"
  task :base_mode do
    purge_firewall_rules
    make_non_permissive
    enable_ip4_forwarding
    explicit_forwarding_only
  end
  
  desc "Transparent Proxy Mode"
  task :transparent_proxy_mode do
    base_mode
    enable_crazy_nat    
  end
  
  desc "Normal Network Address Translation"
  task :normal_nat do
    base_mode
    enable_vanilla_nat
  end

end

