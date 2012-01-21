require 'drb'
require 'set'


class ServerSet
  def initialize
    @set = Set.new
  end

  def <<(item)
    puts "registering #{item}"
    @set << item
    puts "#{@set.inspect}"
    @set
  end

  def delete(item)
    puts "deregistering #{item}"
    @set.delete(item)
    puts "#{@set.inspect}"
    @set
  end

end

servers = ServerSet.new

DRb.start_service "druby://localhost:4080", servers

puts "started coordinator on #{DRb.uri}"

DRb.thread.join
