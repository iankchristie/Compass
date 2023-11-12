//
//  ContentView.swift
//  CompassSender
//
//  Created by Ian Christie on 9/22/23.
//

import Foundation
import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var locationManger = LocationManger.shared
    
    var body: some View {
        Group {
            if locationManger.userLocation == nil {
                PermissionRequestView()
            } else {
                CompassView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
