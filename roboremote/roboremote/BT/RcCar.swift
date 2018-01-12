//
//  RcCar.swift
//  roboremote
//
//  Created by Gustaf Nilklint on 2018-01-11.
//  Copyright © 2018 Tomas Nilsson. All rights reserved.
//

import Foundation

class RcCar {
    var connection : BleConnection
    
    init (connection : BleConnection)
    {
        self.connection = connection
        connection.car = self
    }
    
    var throttleValue : Int8 = 0 {
        didSet {
            if oldValue == throttleValue && throttleValue != 0 {
                return
            }
            connection.writeThrottle(val: throttleValue)
        }
    }
    
    var steeringDirection : Int8 = 0 {
        didSet {
            if oldValue == steeringDirection {
                return
            }
            connection.writeSteeringDir(val: steeringDirection)
        }
    }
}
