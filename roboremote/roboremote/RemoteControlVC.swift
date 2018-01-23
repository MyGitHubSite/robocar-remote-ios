import UIKit

class RemoteControlVC: UIViewController {
    
    var bluetoothEnv = BluetoothEnvironment()
    var car : RcCar?
    @IBOutlet weak var ConnectionLabel: UILabel!
    @IBOutlet weak var connectionImg: UIImageView!
    
    @IBOutlet weak var steeringIndicatorSlider: UISlider!
    @IBOutlet weak var throttleIndicatorView: ThrottleIndicatorView!
    
    @IBOutlet weak var throttleView: UIView!
    @IBOutlet weak var steeringView: UIView!
    
    var connected = false {
        didSet{
            DispatchQueue.main.async {
                if self.connected {
                    self.ConnectionLabel.textColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
                    self.ConnectionLabel.text = "Connected"
                    self.connectionImg.image = #imageLiteral(resourceName: "connected")
                }else{
                    self.ConnectionLabel.text = "Disconnected"
                    self.ConnectionLabel.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                    self.connectionImg.image = #imageLiteral(resourceName: "disconnected")
                }
            }
        }
    }
    
    var throttleStartPnt:CGPoint?
    var throttleRatio: CGFloat = 1
    var throttle : CGFloat = 0.0 {
        didSet {
            //print(throttle)
            self.throttleIndicatorView.throttleInput = throttle
            // invert the value because the joystick interface expects negative value for forward throttle...
            car?.throttleValue = Int8(throttle * -127)
        }
    }
    
    var steerStartPnt:CGPoint?
    var steerRatio: CGFloat = 1
    var steerDirection : CGFloat = 0.0 {
        didSet {
            self.steeringIndicatorSlider.value = Float(steerDirection)
            car?.steeringDirection = Int8(steerDirection * 127)
        }
    }
    
    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bluetoothEnv.startUpCentralManager()
        NotificationCenter.default.addObserver(forName: RCNotifications.ConnectionComplete, object: nil, queue: .main) { (note) in
            self.connected = true
        }
        NotificationCenter.default.addObserver(forName: RCNotifications.DisconnectedDevice, object: nil, queue: .main) { (note) in
            self.connected = false
            self.car = nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        throttle = 0
        steerDirection = 0
        throttleRatio = max(throttleView.bounds.height / 4, 1)
        steerRatio = max(steeringView.bounds.width / 5, 1)
    }

    // controls
    @IBAction func didPanThrottle(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            throttleStartPnt = sender.location(in: throttleView)
        case .changed:
            let ydiff =  throttleStartPnt!.y - sender.location(in: throttleView).y
            var scaledDiff = ydiff / throttleRatio
            if scaledDiff > 1 { scaledDiff = 1 }
            if scaledDiff < -1 { scaledDiff = -1 }
            throttle = scaledDiff
            
        default:
            throttle = 0
            break
        }
    }

    @IBAction func didPanSteering(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            steerStartPnt = sender.location(in: steeringView)
        case .changed:
            let xdiff = sender.location(in: steeringView).x - steerStartPnt!.x
            var scaled = xdiff / steerRatio
            if scaled > 1 { scaled = 1}
            if scaled < -1 { scaled = -1}
            steerDirection = scaled
            break
        default:
            steerDirection = 0
            break
        }
    }
    
    
    // navigation
    @IBAction func unwindWithDevice(segue: UIStoryboardSegue){
        if let src = segue.source as? DiscoveryVC, let selected = src.selectedIndex {
            car = bluetoothEnv.cars[selected]
            if let c = car {
                let periferal = c.connection.peripheral
                bluetoothEnv.connectToDevice(peripheral: periferal)
            }
        }
        else {
            car = nil
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let dest = nav.viewControllers.first as? DiscoveryVC {
            dest.bluetoothEnv = bluetoothEnv
        }
    }
}

