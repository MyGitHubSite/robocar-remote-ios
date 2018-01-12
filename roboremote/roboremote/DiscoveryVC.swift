//
//  DiscoveryVC.swift
//  roboremote
//
//  Created by Gustaf Nilklint on 2018-01-11.
//  Copyright © 2018 Tomas Nilsson. All rights reserved.
//

import UIKit

class DiscoveryVC: UIViewController {

    var bluetoothEnv : BluetoothEnvironment!
    var selectedIndex : Int?
    var scanning = false {
        didSet{
            if scanning {
                bluetoothEnv.discoverDevices()
                self.title = "Scanning..."
                scanButton.title = "Stop scanning"
            }else {
                bluetoothEnv.stopDiscovering()
                self.title = "Discovery"
                scanButton.title = "Start scanning"
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanButton: UIBarButtonItem!
    
    deinit {
        bluetoothEnv.stopDiscovering()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        scanning = false
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: RCNotifications.FoundDevice, object: nil, queue: .main) { (note) in
            self.tableView.reloadData()
        }
        scanning = true
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleScanning(_ sender: UIBarButtonItem) {
        scanning = !scanning
    }
}

extension DiscoveryVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothEnv.cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "periferalRow", for: indexPath)
        cell.textLabel?.text = bluetoothEnv.cars[indexPath.row].connection.peripheral.name
        cell.tag = indexPath.row
        cell.detailTextLabel?.text = bluetoothEnv.cars[indexPath.row].connection.peripheral.identifier.description
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "unwindWithSelection", sender: self)
    }
}
