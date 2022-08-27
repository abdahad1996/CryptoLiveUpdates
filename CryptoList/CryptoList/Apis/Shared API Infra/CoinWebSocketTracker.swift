//
//  CoinWebSocketTracker.swift
//  CryptoList
//
//  Created by ahad on 8/24/22.
//

import Foundation

class CoinWebSocketTracker:NSObject, URLSessionWebSocketDelegate {
    var webSocket: URLSessionWebSocketTask?
    var didRecieveNewCoinPrice: (NewCoinPrice) -> Void = {_ in }
    
     init(url:URL,queue:OperationQueue){
        super.init()
        webSocket = URLSession(configuration: .default, delegate: self, delegateQueue: queue).webSocketTask(with: url)
    }

    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("==> onConnected")
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("==> onDisconnected")
    }
    
    func connect() {
        webSocket?.resume()
        listen()
    }
    
    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
    }
    
    
    func listen()  {
        webSocket?.receive { result in
            switch result {
            case .failure(let error):
                print("==> onFailure \(error.localizedDescription)")
            case .success(let message):
                switch message {
                case .string(let text):
                    let data = Data(text.utf8)
                    if let newCoinPrice =  try? NewCoinLivePriceMapper.map(data) {
                        self.didRecieveNewCoinPrice(newCoinPrice)
                        
                        
                    }
                    
                case .data(let data):
                    print("Data message: \(data)")
                @unknown default:
                    fatalError()
                }
                
                self.listen()
            }
        }
    }
    
    func track(_ coins: [Coin]) {
        let subRequest = [
            "action": "SubAdd",
            "subs": coins.map{$0.subs}
        ] as [String : Any]
        
        if let requestString = subRequest.toJSONString() {
            send(text: requestString)
        }
    }
    func send(text: String) {
        webSocket?.send(URLSessionWebSocketTask.Message.string(text)) { error in
            if let error = error {
                print("==> onError \(error.localizedDescription)")
            }
        }
    }
    
    func send(data: Data) {
        webSocket?.send(URLSessionWebSocketTask.Message.data(data)) { error in
            if let error = error {
                print("==> onError \(error.localizedDescription)")
            }
        }
    }
}
