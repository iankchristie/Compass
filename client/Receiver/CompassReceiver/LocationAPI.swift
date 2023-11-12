//
//  LocationAPI.swift
//  CompassReceiver
//
//  Created by Ian Christie on 10/2/23.
//

import Foundation

class LocationAPI {
    let locationUrl = URL(string: "https://location.iankchristie.com/location")!
    
    func getServerLocation(completion:@escaping (Location) -> ()) {
        URLSession.shared.dataTask(with: locationUrl) { data,_,_  in
            let location = try! JSONDecoder().decode(Location.self, from: data!)
            
            DispatchQueue.main.async {
                completion(location)
            }
        }
        .resume()
    }
}

