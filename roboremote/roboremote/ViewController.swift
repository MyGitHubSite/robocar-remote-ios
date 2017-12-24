import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var throttleIndicatorView: ThrottleIndicatorView!
    
    @IBOutlet weak var throttleView: UIView!
    @IBOutlet weak var steeringView: UIView!
    
    var throttleStartPnt:CGPoint?
    var throttleRatio: CGFloat = 1
    var throttle : CGFloat = 0.0 {
        didSet {
            print(throttle)
            self.throttleIndicatorView.throttleInput = throttle
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
            let ydiff =  throttleStartPnt!.y - sender.location(in: throttleView).y
            var scaledDiff = ydiff / throttleRatio
            if scaledDiff > 1 {
                scaledDiff = 1
            }
            if scaledDiff < -1 {
                scaledDiff = -1
            }
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
            let xdiff = sender.translation(in: steeringView).x
            break
        default:
            break
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

