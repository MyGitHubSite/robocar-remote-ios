//
//  BleConnection.swift
//  roboremote
//
//  Created by Gustaf Nilklint on 2018-01-11.
//  Copyright © 2018 Tomas Nilsson. All rights reserved.
//

import CoreBluetooth

class BleConnection: NSObject, CBPeripheralDelegate {
    
    var peripheral : CBPeripheral
    weak var car : RcCar!
    
    var throttleValChar : CBCharacteristic?
    var steeringChar : CBCharacteristic?
    
    init(peripheral: CBPeripheral)
    {
        self.peripheral = peripheral
        super.init()
        peripheral.delegate = self
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            print("Found service \(service)")
            if service.uuid == BLEParameters.RcCarService {
                peripheral.discoverCharacteristics(nil, for: service )
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for i in service.characteristics!
        {
            print("Found characteristic \(i)")
            switch i.uuid {
            case BLEParameters.throttleChar:  throttleValChar = i
            case BLEParameters.steeringChar: steeringChar = i
            default: break
            }
        }
        NotificationCenter.default.post(name: RCNotifications.ConnectionComplete, object: nil)
    }
    
    
    func writeThrottle(val : Int8)
    {
        if let char = throttleValChar {
            bleWriteInt8(val, char: char)
        }
    }
    
    func writeSteeringDir(val : Int8)
    {
        if let char = steeringChar {
            bleWriteInt8(val, char: char)
        }
    }
    
    private func bleWriteInt8(_ val: Int8, char: CBCharacteristic)
    {
        var val = val
        let nsdata = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
        peripheral.writeValue(nsdata as Data, for: char, type: CBCharacteristicWriteType.withoutResponse)
    }
    
}
