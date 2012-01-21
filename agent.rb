require 'drb'

DRb.start_service("druby://localhost:490#{ARGV[0]}")

puts "server started at #{DRb.uri}"

servers = DRbObject.new nil, "druby://localhost:4080"

servers << DRb.uri

trap("SIGINT") { servers.delete(DRb.uri); exit! }

DRb.thread.join

