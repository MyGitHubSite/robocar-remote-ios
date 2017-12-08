import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var throttleIndicatorView: UIView!
    @IBOutlet weak var fwHeight: NSLayoutConstraint!
    @IBOutlet weak var rvHeight: NSLayoutConstraint!
    
    @IBOutlet weak var throttleView: UIView!
    @IBOutlet weak var steeringView: UIView!
    
    var throttleStartPnt:CGPoint?
    var throttleRatio: CGFloat = 1
    var throttle : CGFloat = 0.0 {
        didSet {
            print(throttle)
        }
    }
    
    var steerStartPnt:CGPoint?
    var steerRatio: CGFloat = 1
    var steerDirection : CGFloat = 0.0 {
        didSet {
            print(steerDirection)
        }
    }

    @IBAction func didPanThrottle(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            throttleStartPnt = sender.location(in: throttleView)
        case .changed:
            let ydiff =  sender.location(in: throttleView).y - throttleStartPnt!.y
            var scaledDiff = ydiff / throttleRatio
            if scaledDiff > 1 {
                scaledDiff = 1
            }
            if scaledDiff < -1 {
                scaledDiff = -1
            }
            updateThrottleindicator(throttleAmnt: scaledDiff)
            throttle = scaledDiff
            
        default:
            updateThrottleindicator(throttleAmnt: 0)
            throttle = 0
            break
        }
    }

    @IBAction func didPanSteering(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            steerStartPnt = sender.location(in: steeringView)
        case .changed:
            let xdiff = sender.translation(in: steeringView).x
            break
        default:
            break
        }
    }
    
    func updateThrottleindicator(throttleAmnt throttle: CGFloat) {
        if throttle < 0 {
            // forward
            let scaledThrottle = throttle / -2
            rvHeight.constant = 0
            fwHeight.constant = throttleIndicatorView.bounds.height * scaledThrottle
        }else {
            // reverse
            let scaledThrottle = throttle / 2
            rvHeight.constant = throttleIndicatorView.bounds.height * scaledThrottle
            fwHeight.constant = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        throttle = 0
        steerDirection = 0
        throttleRatio = max(throttleView.bounds.height / 4, 1)
        steerRatio = max(steeringView.bounds.width / 4, 1)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

