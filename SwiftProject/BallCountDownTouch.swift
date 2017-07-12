
//
//  BallCountDownTouch.swift
//  SwiftProject
//
//  Created by SXJH on 2017/6/12.
//  Copyright © 2017年 SXJH. All rights reserved.
//

import UIKit

let maxDistance:CGFloat = 50


class BallCountDownTouch: UIWindow {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    var ballCountView:BallCountDownView!
    
    lazy var smallCicreView:UIView? = {
        let smallView = UIView.init()
        smallView.backgroundColor = UIColor.red
        return smallView
    }()
    
    lazy var shapeLayer:CAShapeLayer?={
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.fillColor = UIColor.red.cgColor
        
        return shapeLayer
    }()
    
    class var sharedInstance: BallCountDownTouch {
        struct Static {
            static let instance: BallCountDownTouch = BallCountDownTouch.init(frame: CGRect.init(x: UIScreen.main.bounds.size.width-49, y: 100, width: 49, height: 49))
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
        
        
        self.smallCicreView?.bounds = CGRect.init(x: 0, y: 0, width: ballCountDownView.bounds.size.width, height: ballCountDownView.bounds.size.height)
        smallCicreView?.center = CGPoint.init(x: ballCountDownView.center.x+ballCountDownView.frame.size.width/2 - (self.smallCicreView?.frame.width)!/2, y: ballCountDownView.center.y)
        ballCountDownView.insertSubview(smallCicreView!, at: 0)
        ballCountDownView.layer.insertSublayer(self.shapeLayer!, below: self.smallCicreView?.layer)
        
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
            
            let distance = distanceWithPointA(pointA: ballCountView.center, pointB: (self.smallCicreView?.center)!)
        
            if distance < maxDistance {
//                var radius: CGFloat = pan.view!.bounds.size.width > pan.view!.bounds.size.height ? pan.view!.bounds.size.width*0.5 : pan.view!.bounds.size.height*0.5
                self.smallCicreView?.bounds = CGRect.init(x:0, y:0,width: 10,height: 10)
                self.smallCicreView?.layer.cornerRadius = (10)*0.5
                if smallCicreView?.isHidden == false && distance > 0 {
                    self.shapeLayer?.path = self.pathWithBigCirCleView(bigCircleView: self, smallCircleView: smallCicreView).cgPath
                }

            }else{
                
            }
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
    
    private func distanceWithPointA(pointA:CGPoint,pointB:CGPoint) -> CGFloat {
        let x: CGFloat = pointA.x-pointB.x
        let y: CGFloat = pointA.y-pointB.y
        return CGFloat(sqrtf(Float(x*x+y*y)))
    }
    
    private func pathWithBigCirCleView(bigCircleView:UIView!,smallCircleView:UIView!) -> UIBezierPath {
        let bigCenter: CGPoint = bigCircleView.center
        let bigX: CGFloat = bigCenter.x
        let bigY: CGFloat = bigCenter.y
        let bigRadius: CGFloat = bigCircleView.bounds.size.width*0.5
        let smallCenter: CGPoint = smallCircleView.center
        let smallX: CGFloat = smallCenter.x
        let smallY: CGFloat = smallCenter.y
        let smallRadius: CGFloat = smallCircleView.bounds.size.width*0.5
        let d: CGFloat = distanceWithPointA(pointA: smallCenter, pointB: bigCenter)
        let sina: CGFloat = (bigX-smallX)/d
        let cosa: CGFloat = (bigY-smallY)/d
        let pointA: CGPoint = CGPoint.init(x: smallX-smallRadius*cosa, y: smallY+smallRadius*sina)
        let pointB: CGPoint = CGPoint.init(x: smallX+smallRadius*cosa, y: smallY-smallRadius*sina)
        let pointC: CGPoint = CGPoint.init(x: bigX+bigRadius*cosa, y: bigY-bigRadius*sina)
        let pointD: CGPoint = CGPoint.init(x: bigX-bigRadius*cosa, y: bigY+bigRadius*sina)
        let pointO: CGPoint = CGPoint.init(x: pointA.x+d/6*sina, y: pointA.y+d/6*cosa)
        let pointP: CGPoint = CGPoint.init(x: pointB.x+d/6*sina, y: pointB.y+d/6*cosa)
        let path: UIBezierPath = UIBezierPath()
        // A
        path.move(to: pointA)
        // AB
        path.addLine(to: pointB)
        // 绘制BC曲线
        path.addQuadCurve(to: pointC, controlPoint: pointP)
        // CD
        path.addLine(to: pointD)
        // 绘制DA曲线
        path.addQuadCurve(to: pointA, controlPoint: pointO)
        return path

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


