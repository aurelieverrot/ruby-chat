require 'socket'

server = TCPServer.new 2000 # Server bound to port 2000
puts "I'm ready to accept new clients on port 2000"

clients = []

def handle_client(clients, client)
  client_name = client.gets.chomp

  client.puts "Hello #{client_name}! Clients connected: #{clients.count}"

  announce_to_everyone(clients, "#{client_name} joined!")

  while line = client.gets
    incoming_data_from_client = line.chomp
    announce_to_everyone clients, "#{client_name}: #{incoming_data_from_client}"
  end
  client.close
  clients.delete(client)
  announce_to_everyone(clients, "#{client_name} left!")
end

def announce_to_everyone(clients, text)
  clients.each { |client| client.puts text }
end

loop do
  client = server.accept    # Wait for a client to connect
  clients << client
  Thread.new {
    handle_client(clients, client)
  }
end
