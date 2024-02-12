require "socket"

server = TCPServer.new("localhost", 3003)

puts "Web Server started at http://localhost:3003/"

# シグナルハンドラ（Ctrl+Cを処理する）
trap("INT") do
  puts "Shutting down..."
  exit
end


def response_html
  # レスポンスヘッダー
  response = "HTTP/1.1 200 OK\r\n"
  response << "Content-Type: text/html\r\n"
  response << "\r\n"
  # レスポンスボディ
  response << File.read("../views/index.html")
end

loop do
  client = server.accept

  request_line = client.gets
  puts request_line

  client.puts response_html

  client.close
end
