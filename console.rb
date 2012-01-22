require 'drb'

DRb.start_service("druby://localhost:4000", nil)

def refresh_servers
  $servers = [] 
  nodes = DRbObject.new nil, "druby://localhost:4080"
  nodes.each do |node|
    $servers << DRbObject.new(nil, node)
  end
  $servers.each_with_index do |serv, i|
    puts "[#{i}] #{serv}" 
  end
end

require 'irb'  
IRB.setup(nil)
irb = IRB::Irb.new

IRB.conf[:MAIN_CONTEXT] = irb.context

irb.context.evaluate("require 'irb/completion'", 0)

trap("SIGINT") do
  irb.signal_handle
end

catch(:IRB_EXIT) do
  irb.eval_input
end
