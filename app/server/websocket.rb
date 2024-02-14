require "socket"
require "digest/sha1"

# WSハンドシェイクに使用されるソルト
WS_GUID = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"

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

def get_websocket_accept_key(request)
  websocket_key = get_websocket_key(request)
  return if websocket_key.nil?

  Digest::SHA1.base64digest([websocket_key, WS_GUID].join)
end

def get_websocket_key(request)
  matches = request.match(/^Sec-WebSocket-Key: (\S+)/)
  return if matches.nil?

  matches[1]
end

def response_data(websocket_accept_key)
  [
    "HTTP/1.1 101 Switching Protocols",
    "Upgrade: websocket",
    "Connection: Upgrade",
    "Sec-WebSocket-Accept: #{websocket_accept_key}",
    "\r\n"
  ].join("\r\n")
end

loop do
  client = server.accept

  # HTTPリクエストヘッダーを取得
  http_request = get_http_request(client)
  puts http_request

  # リクエストヘッダーからSec-WebSocket-Keyを取得
  # 取得したSec-WebSocket-KeyにGUIDをくっつけてハッシュ化&Base64エンコーディングしてSec-WebSocket-Acceptを生成
  # クライアント側ではこのkeyを使って、WS接続を確立する
  websocket_accept_key = get_websocket_accept_key(http_request)
  # WS通信以外の場合はコネクションを閉じて次のリクエストを待つ
  if websocket_accept_key.nil?
    client.close
    next
  end

  # レスポンスを送信
  # ハンドシェイクのためのリクエストに対し、WSプロトコルでの通信への更新完了を返す
  client.write(response_data(websocket_accept_key))

  client.close
end
