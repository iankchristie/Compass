//
//  ContentView.swift
//  CompassSender
//
//  Created by Ian Christie on 9/22/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @ObservedObject var locationManger = LocationManger.shared
    @State var serverLocation: CLLocationCoordinate2D?
    @State var allowingAutomaticUpdates: Bool = false
    @State var switchingAutomaticUpdates: Bool = false
    @State var settingServerLoaction: Bool = false
    @State var pinLocation :CLLocationCoordinate2D? = nil
    
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Group {
            if locationManger.userLocation == nil {
                LocationRequestView()
            } else {
                VStack {
                    let deviceCoordinates = locationManger.userLocation?.coordinate
                    if (deviceCoordinates != nil
                        && serverLocation != nil
                    ) {
                        MapReader{ reader in
                            Map() {
                                Marker("Device Location", coordinate: deviceCoordinates!)
                                    .tint(.blue)
                                Marker("Server Location", coordinate: serverLocation!)
                                if let pl = pinLocation {
                                    Marker("(\(pl.latitude), \(pl.longitude))", coordinate: pl)
                                }
                            }
                            .onTapGesture(perform: { screenCoord in
                                pinLocation = reader.convert(screenCoord, from: .local)
                            })
                        }
                    } else {
                        Map()
                    }
                    Text("Device Location: \(locationManger.userLocation?.coordinate.latitude.formatted() ?? "not loaded"), \(locationManger.userLocation?.coordinate.longitude.formatted() ?? "not loaded")")
                    Text("Server Location: \(serverLocation?.latitude.formatted() ?? "not loaded"), \(serverLocation?.longitude.formatted() ?? "not loaded")")
                    HStack {
                        Button("Clear Pin") {
                            pinLocation = nil
                        }
                        .disabled(pinLocation == nil)
                        .padding()
                        Spacer()
                        Button(settingServerLoaction ? "Setting Server Location" : "Set Server Location") {
                            self.settingServerLoaction = true
                            let newLocation = Location(latitude: pinLocation!.latitude, longitude: pinLocation!.longitude)
                            LocationAPI().setServerLocation(location: newLocation, update_type: "manual")
                            pinLocation = nil
                        }
                        .disabled(pinLocation == nil)
                        .padding()
                    }
                    Button(switchingAutomaticUpdates ? "Switching Automatic Updates" :
                            (allowingAutomaticUpdates ? "Pause Automatic Updates" : "Allow Automatic Updates")) {
                        self.switchingAutomaticUpdates = true
                        LocationAPI().setServerAllowAutomaticUpdates(allowAutomaticUpdates: !allowingAutomaticUpdates)
                    }
                            .padding()
                }.onAppear() {
                    LocationAPI().getServerLocation { (location) in
                        self.serverLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        self.settingServerLoaction = false
                    }
                    LocationAPI().getServerAllowAutomaticUpdates { (allowAutomaticUpdatesResponse) in
                        self.allowingAutomaticUpdates = allowAutomaticUpdatesResponse
                        self.switchingAutomaticUpdates = false
                    }
                }.onReceive(timer) { _ in
                    LocationAPI().getServerLocation { (location) in
                        self.serverLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                        self.settingServerLoaction = false
                    }
                    LocationAPI().getServerAllowAutomaticUpdates { (allowAutomaticUpdatesResponse) in
                        self.allowingAutomaticUpdates = allowAutomaticUpdatesResponse
                        self.switchingAutomaticUpdates = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
