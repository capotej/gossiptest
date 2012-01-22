require 'drb'


class Agent

  def inspect
    "<Agent: #{@id}>"
  end
  def initialize(i)
    @id = i
  end
  
  def ping
    puts "pong from #{@id}"
  end
end

agent = lambda do |i|

  agent_class = Agent.new(i)

  DRb.start_service("druby://localhost:490#{i}", agent_class)

  puts "server started at #{DRb.uri}"

  servers = DRbObject.new nil, "druby://localhost:4080"

  servers << DRb.uri

  trap("SIGINT") { servers.delete(DRb.uri); exit! }
  trap("SIGTERM") { servers.delete(DRb.uri); exit! }
  trap("SIGWINCH") { puts "Asdasda" }

  DRb.thread.join
end

ARGV[0].to_i.times do |i|
  $iter = i
  pid = fork do
    agent.call($iter)
  end
end
