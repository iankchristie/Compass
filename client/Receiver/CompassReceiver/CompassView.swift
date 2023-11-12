//
//  CompassView.swift
//  CompassReceiver
//
//  Created by Ian Christie on 11/10/23.
//

import SwiftUI

struct CompassView: View {
    @State var hideDetails = true
    @State var viewModel = CompassViewModel()

    var body: some View {
        ZStack {            
            VStack {
                Text("Reciever")
                Text("Device Location: \(viewModel.deviceLocation.latitude.formatted() ), \(viewModel.deviceLocation.longitude.formatted() )")
                Text("Server Location: \(viewModel.serverLocation.latitude.formatted() ), \(viewModel.serverLocation.latitude.formatted() )")
                Text("Coordinate Bearing: \(viewModel.bearing.formatted())")
                Text("Device Azimuth \(viewModel.coordinateHeading)")
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .hidden(hideDetails)
                        
            Image("ian_cropped")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .rotationEffect(.degrees(-viewModel.coordinateHeading + viewModel.bearing))
                .padding()
            
            VStack {
                Button("Show Details") {
                    hideDetails = !hideDetails
                }
                .padding()
                .opacity(0.1)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .onReceive(CompassViewModelPublisher.shared.state) { viewModel in
            self.viewModel = viewModel
        }
    }
}

#Preview {
    CompassView()
}
