# メモ
## WebSocketとは
サーバーとクライアント間の永続的な TCP 接続を可能にするプロトコル。  
HTTP通信ではユーザー起点で情報のやり取りを行うが、WebSocketでは、クライアントとサーバーの双方向に情報のやり取りが、一つのコネクションで行える。  
ヘッダーが小さく、通信のオーバーヘッドが少なくなるように設計されている。

## WebSocketの歴史
JSの発達に伴い非同期通信が盛んに行われるようになった。  
そこで、クライアント側からの通信だけでなく、サーバー側からの通信の需要が高まり、WebSocketの技術が開発された。  
WebSocket以外だと、ロングポーリングの技術を使ったCometなどがある。
<details>
<summary>Cometとは</summary>
&nbsp&nbsp ロングポーリング（タイムアウトギリギリまで通信を引き伸ばす）を使用して、その間に発生した変更をまとめて返す方法。<br/>
&nbsp&nbsp Cometには下記のような問題があり、WebSocketが普及していった。  
<ul>
  <li>スケーラビリティ</li>
  長時間のHTTP接続が発生するため、リソース消費が増加する。
  <li>ネットワークの遅延</li>
  タイムアウトギリギリまでレスポンスを引き延ばすため、ラグが発生するケースが存在する。
</ul>
</details>

## WebSocket導入前に...
WebSocketを入れると、セキュリティ、テスト、実装が複雑になる。  
本当にリアルタイム性が必要かを十分に検討した上で導入する必要がある。   
（参考）[これからWebSocketを導入しようと考える前に読んでほしい](https://zenn.dev/dove/articles/9c869cd46e1a5a)

## ws://とwss://
httpとhttpsと同じように暗号化が挟まるかどうかの違い
wsは、リクエスト => TCP => WebSocketの間の通信経路で、HTTPプロトコルと異なるデータが流れてくるので、どこがで引っかかってしまう可能性を含んでいる。
一方wssは、リクエスト => TCP => SSL/TSL => WebSocketの流れなので、通信経路の段階では暗号化されているため引っかかりにくい。


## 関連技術
### Socket.io
サーバーがWebSocketに対応していなくても、ロングポーリングを自動でやってくれる。  
room機能があるので、決まったグループに一斉送信したいときにも使う。

### Redisとの関係
複数のサーバーとクライアントでデータの同期と送受信を行う必要がある場合ケースでRedisが活躍する。  
例えば、ユーザーAのアクションを別WSサーバと接続するユーザーB, Cに同期させたい場合、  
Pub/Sub機能を使って、ユーザーA => WSサーバーA => Redis => WSサーバーA,B,C => ユーザーA,B,C のように情報が流れる。  
接続情報や揮発性を許容できるデータをRedisに保存しておけば、インメモリなので高速に処理が行える。  
```
　　　　　　  Redisサーバー  
　　　　┏━━━━━━━━━━╋━━━━━━━━━━┓  
 WSサーバーA   WSサーバーB   WSサーバーC  
 　　┃　　　　　　  ┃　         ┣━━━━━━━━━┓━━━━━━━━━┓  
  ユーザーA     ユーザーB    ユーザーC　ユーザーD　ユーザーE  
```

## 関連記事
- [RubyでシンプルなWebSocketサーバーをゼロからつくってみた](https://zenn.dev/mesi/articles/0dbe8e182e4e4a)
- [Building a simple websockets server from scratch in Ruby](https://www.honeybadger.io/blog/building-a-simple-websockets-server-from-scratch-in-ruby/)
- [RedisのPub/Subを活用してユーザー情報をリアルタイムに反映「同時」にこだわったLINE LIVEの同期システム](https://logmi.jp/tech/articles/325524)
- [WebSocket / WebRTCの技術紹介](https://www.slideshare.net/mawarimichi/websocketwebrtc)
