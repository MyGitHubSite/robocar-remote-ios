//
//  Constants.swift
//  roboremote
//
//  Created by Gustaf Nilklint on 2018-01-11.
//  Copyright © 2018 Tomas Nilsson. All rights reserved.
//

import CoreBluetooth

//  Identify the NSNotification Messages
struct RCNotifications {
    static let FoundDevice = NSNotification.Name(rawValue: "com.jayway.roboremote.founddevice")
    static let ConnectionComplete = NSNotification.Name(rawValue:"com.jayway.roboremote.connectioncomplete")
    static let DisconnectedDevice = NSNotification.Name(rawValue:"com.jayway.roboremote.disconnecteddevice")
    
    static let UpdatedThrottle = NSNotification.Name(rawValue:"com.jayway.roboremote.updatedthrottle")
    static let UpdatedSteering = NSNotification.Name(rawValue:"com.jayway.roboremote.updatedsteering")
    
}

// Identify the UUIDs of the services and characteristics for the Robot
struct BLEParameters {
    static let RcCarService = CBUUID(string: "00000000-0000-1000-8000-00805F9B34F0")
    static let throttleChar = CBUUID(string:"00000000-0000-1000-8000-00805F9B34F1")
    static let steeringChar = CBUUID(string:"00000000-0000-1000-8000-00805F9B34F2")
}
