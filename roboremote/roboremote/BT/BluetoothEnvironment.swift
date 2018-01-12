//
//  BluetoothEnvironment.swift
//  roboremote
//
//  Created by Gustaf Nilklint on 2018-01-11.
//  Copyright © 2018 Tomas Nilsson. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothEnvironment : NSObject {
    var centralManager : CBCentralManager!
    var cars = [RcCar]()
    
    private var blueToothReady = false
    
    func startUpCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    func discoverDevices() {
        if blueToothReady {
            print("starting discovery")
            centralManager.scanForPeripherals(withServices: [BLEParameters.RcCarService],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey:false])
        }
    }
    
    func stopDiscovering() {
        print("Stopping discovery")
        centralManager.stopScan()
    }
    
    func connectToDevice(peripheral: CBPeripheral)
    {
        centralManager.connect(peripheral, options: nil)
    }
    
    func disconnectDevice(peripheral : CBPeripheral)
    {
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

extension BluetoothEnvironment : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("central updated to state: \(central.state.rawValue)")
        switch central.state {
        case .poweredOn:
            blueToothReady = true
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection complete")
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect")
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        print("Disconnected \(peripheral)")
        NotificationCenter.default.post(name: RCNotifications.DisconnectedDevice, object: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if searchDevices(peripheral: peripheral) == nil {
            print("Found a new Periphal advertising matching service")
            let newCar = RcCar(connection: BleConnection(peripheral: peripheral))
            cars.append(newCar)
            NotificationCenter.default.post(name: RCNotifications.FoundDevice, object: nil)
        }
    }
    
    func searchDevices(peripheral : CBPeripheral) -> Int?
    {
        for (index, device) in cars.enumerated() {
            if device.connection.peripheral == peripheral {
                return index
            }
        }
        return nil
    }
}
