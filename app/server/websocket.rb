require "socket"

server = TCPServer.new("localhost", 2345)

puts "WS Server started at http://localhost:2345/"

trap("INT") do
  puts "Shutting down..."
  exit
end

def get_http_request(client)
  request_header = ""
  while (line = client.gets) && (line != "\r\n")
    request_header += line
  end

  request_header
end

loop do
  client = server.accept

  http_request = get_http_request(client)
  puts http_request

  client.close
end
