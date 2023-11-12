//
//  ServerLocationPublisher.swift
//  CompassReceiver
//
//  Created by Ian Christie on 11/10/23.
//

//import Foundation
//import Combine
//
//class ServerLocationPublisher {
//    static let shared = ServerLocationPublisher()
//
//    var location = Timer.publish(every: 5, on: .current, in: .common)
//        .autoconnect()
//        .flatMap {_ in
//            return LocationService().getServerLocation()
//        }
//        .merge(with: LocationService().getServerLocation())
//        .receive(on: RunLoop.main)
//        .eraseToAnyPublisher()
//}
