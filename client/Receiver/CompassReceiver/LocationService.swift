//
//  LocationServiceV2.swift
//  CompassReceiver
//
//  Created by Ian Christie on 11/10/23.
//

import Foundation
import Combine

struct LocationService {
    static let shared = LocationService()
    let serverLocationPublisher = PassthroughSubject<Location, any Error>()
    private var webSocketTask: URLSessionWebSocketTask?

    init() {
        self.connect()
        self.startHeartBeat()
    }
    
    private mutating func connect() {
        guard let url = URL(string: "wss://location.iankchristie.com") else { return }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { result in
            print("Received websocket data")
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received websocket data: " + text)
                    if (text != "pong") {
                        do {
                            let decoder = JSONDecoder()
                            let location = try decoder.decode(Location.self, from: text.data(using: .utf8)!)
                            serverLocationPublisher.send(location)
                        } catch {
                            print("JSONSerialization error:", error)
                        }
                    }
                case .data(_):
                    // Handle binary data
                    break
                @unknown default:
                    break
                }
            }
            
            self.receiveMessage()
        }
    }
    
    func sendMessage(_ message: String) {
        guard message.data(using: .utf8) != nil else { return }
        webSocketTask?.send(.string(message)) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func ping() {
        sendMessage("ping")
    }
    
    func startHeartBeat() {
        Timer.scheduledTimer(withTimeInterval: 50.0, repeats: true) { timer in
            self.ping()
        }
    }
}
