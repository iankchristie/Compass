//
//  PermissionRequestImageView.swift
//  CompassReceiver
//
//  Created by Ian Christie on 10/4/23.
//

import SwiftUI

struct PermissionRequestView: View {
    var body: some View {
        ZStack {
            Color(.systemBlue).ignoresSafeArea()
            
            VStack {
                Button {
                    LocationManger.shared.requestLocation()
                } label: {
                    Text("Allow Location")
                        .padding()
                        .font(.headline)
                        .foregroundColor(Color(.systemBlue))
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.horizontal, -32)
                .background(Color.white)
                .clipShape(Capsule())
                .padding()
            }
        }
        
    }
}

struct PermissionRequestView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionRequestView()
    }
}
