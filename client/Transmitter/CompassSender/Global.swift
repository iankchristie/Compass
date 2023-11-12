//
//  Global.swift
//  CompassSender
//
//  Created by Ian Christie on 10/6/23.
//

import Foundation

class Global : NSObject {
    static let shared = Global()
    var launchedFromLocation = false

    override init() {
        super.init()
    }
}
