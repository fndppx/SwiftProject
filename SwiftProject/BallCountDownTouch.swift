
//
//  BallCountDownTouch.swift
//  SwiftProject
//
//  Created by SXJH on 2017/6/12.
//  Copyright © 2017年 SXJH. All rights reserved.
//

import UIKit

class BallCountDownTouch: UIWindow {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var ballCountView:BallCountDownView!
    
    
    class var sharedInstance: BallCountDownTouch {
        struct Static {
            static let instance: BallCountDownTouch = BallCountDownTouch.init(frame: CGRect.init(x: 0, y: 100, width: 49, height: 49))
        }
        
        return Static.instance
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.makeKeyAndVisible()
        self.isHidden = true

        let array:Array = Bundle.main.loadNibNamed("BallCountDownView", owner: self, options: nil)!
        let ballCountDownView:BallCountDownView = array[0] as! BallCountDownView
        ballCountDownView.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        ballCountDownView.layer.cornerRadius = frame.size.width/2
        self.addSubview(ballCountDownView)
        ballCountView = ballCountDownView
        let panGesture:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(changePostion(pan:)))
        ballCountDownView.addGestureRecognizer(panGesture)
    }
   
    func dissMiss () {
       self.isHidden = true
    }
    
    func show()  {
        self.isHidden = false
    }
    
    func changePostion(pan:UIPanGestureRecognizer) {
        let point:CGPoint = pan.translation(in: self)
        
        let width:CGFloat = UIScreen.main.bounds.width
        let height:CGFloat = UIScreen.main.bounds.height
        
        var originalFrame = self.frame
        if originalFrame.origin.x >= 0 && originalFrame.origin.x + originalFrame.size.width <= width {
            originalFrame.origin.x += point.x
        }
        
        if originalFrame.origin.y >= 0 && originalFrame.origin.y + originalFrame.size.height <= height {
            originalFrame.origin.y += point.y
        }
        self.frame = originalFrame
        pan.setTranslation(CGPoint.zero, in: self)
        
        switch pan.state {
        case UIGestureRecognizerState.began:
            ballCountView.interactionButton.isEnabled = false
            break
        case UIGestureRecognizerState.changed:
            break
        default:
            var frame = self.frame
            //超出边界
            if frame.origin.x < 0 {
                frame.origin.x = 0
            }else if frame.origin.x + frame.size.width > width{
                frame.origin.x = width - frame.size.width
            }
            
            if frame.origin.y < 0 {
                frame.origin.y = 0
            }else if frame.origin.y + frame.size.height > height{
                frame.origin.y = height - frame.size.height
            }
            //粘贴方向
            if frame.origin.x+frame.size.width/2>width/2 {
                frame.origin.x = width - frame.size.width;
            }
            else if frame.origin.x+frame.size.width/2<=width/2
            {
                frame.origin.x = 0;
            }
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: {
                self.frame = frame
            }, completion: nil)
            ballCountView.interactionButton.isEnabled = true
            
            break
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
