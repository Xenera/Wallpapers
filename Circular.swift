

import UIKit

class Circular: NSObject {

    var circle = UIView()
    
    var starttingPoint = CGPoint.zero {
        didSet {
            circle.center = starttingPoint
        }
    }
    
    var circleColor = UIColor.whiteColor()
    
    var duration = 0.3
    
    enum CircularTransitionMode : Int {
        case present, dismiss, pop
    }
    
    var transitionMode : CircularTransitionMode = .present
}

extension Circular : UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        
        if transitionMode == .present {
            if let presentedView = transitionContext.viewForKey(UITransitionContextToViewKey) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: starttingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = starttingPoint
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransformMakeScale(0.001, 0.001)
                
                
                containerView?.addSubview(circle)
                
                presentedView.center = starttingPoint
                presentedView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                presentedView.alpha = 0
                containerView!.addSubview(presentedView)
                
                UIView.animateWithDuration(duration, animations: {
                    self.circle.transform = CGAffineTransformIdentity
                    presentedView.transform = CGAffineTransformIdentity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                    }, completion: { (success : Bool) in
                        transitionContext.completeTransition(success)
                })
                
            }
            
        } else {
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextToViewKey : UITransitionContextFromViewKey
            if let returnningView = transitionContext.viewForKey(transitionModeKey) {
                let viewCenter = returnningView.center
                let viewSize = returnningView.frame.size
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: starttingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.width / 2
                circle.center = starttingPoint
                
                UIView.animateWithDuration(duration, animations: {
                    self.circle.transform = CGAffineTransformMakeScale(0.001, 0.001)
                    returnningView.transform = CGAffineTransformMakeScale(0.001, 0.001)
                    
                    returnningView.center = self.starttingPoint
                    returnningView.alpha = 0
                    
                    if self.transitionMode == .pop {
                        containerView?.insertSubview(returnningView, aboveSubview: returnningView)
                        containerView?.insertSubview(self.circle, aboveSubview: returnningView)
                    }
                    }, completion: { (success: Bool) in
                        returnningView.center = viewCenter
                        returnningView.removeFromSuperview()
                        
                        self.circle.removeFromSuperview()
                        
                        transitionContext.completeTransition(success)
                })
            }
        }
    }
    
    func frameForCircle (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) / 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
