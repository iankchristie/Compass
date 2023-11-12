//
//  LocationAPI.swift
//  CompassSender
//
//  Created by Ian Christie on 10/2/23.
//

import Foundation

class LocationAPI {
    let locationUrl = URL(string: "https://location.iankchristie.com/location")!
    let allowAutomaticUpdatesUrl = URL(string: "https://location.iankchristie.com/allow_automatic_updates")!
    
    func getServerLocation(completion:@escaping (Location) -> ()) {
        URLSession.shared.dataTask(with: locationUrl) { data,_,_  in
            let location = try! JSONDecoder().decode(Location.self, from: data!)
            
            DispatchQueue.main.async {
                completion(location)
            }
        }
        .resume()
    }
    
    func getServerAllowAutomaticUpdates(completion:@escaping (Bool) -> ()) {
        URLSession.shared.dataTask(with: allowAutomaticUpdatesUrl) { data,_,_  in
            let response = try! JSONDecoder().decode(AllowAutomaticUpdates.self, from: data!)
            
            DispatchQueue.main.async {
                completion(response.allow_automatic_updates)
            }
        }
        .resume()
    }
    
    func setServerLocation(location: Location, update_type: String) {
        let parameters: [String: Any] = ["latitude": location.latitude, "longitude": location.longitude, "update_type": update_type]

        // now create the URLRequest object using the url object
        var request = URLRequest(url: locationUrl)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        // create dataTask using the session object to send data to the server
        URLSession.shared.dataTask(with: request) { data, response, error in
          if let error = error {
            print("Post Request Error: \(error.localizedDescription)")
            return
          }
          
          // ensure there is valid response code returned from this HTTP response
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
          else {
            print("Invalid Response received from the server")
            return
          }
        }
        .resume()
    }
    
    func setServerAllowAutomaticUpdates(allowAutomaticUpdates: Bool) {
        let parameters: [String: Any] = ["allow_automatic_updates": allowAutomaticUpdates]

        // now create the URLRequest object using the url object
        var request = URLRequest(url: allowAutomaticUpdatesUrl)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
          // convert parameters to Data and assign dictionary to httpBody of request
          request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
          print(error.localizedDescription)
          return
        }
        
        // create dataTask using the session object to send data to the server
        URLSession.shared.dataTask(with: request) { data, response, error in
          if let error = error {
            print("Post Request Error: \(error.localizedDescription)")
            return
          }
          
          // ensure there is valid response code returned from this HTTP response
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
          else {
            print("Invalid Response received from the server")
            return
          }
        }
        .resume()
    }

}
