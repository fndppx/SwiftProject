
//
//  BallCountDownView.swift
//  SwiftProject
//
//  Created by SXJH on 2017/6/12.
//  Copyright © 2017年 SXJH. All rights reserved.
//
let minutes = 60.0
import UIKit

class BallCountDownView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var interactionButton: UIButton!
    var currentRestTime:Double = 30*minutes{
        willSet(newValue){
            self.currentRestTime = newValue
            
        }
        didSet{
            self.setRestTime(restTime: currentRestTime)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setRestTime(restTime:Double)  {
        let duration:Double = floor(restTime)
//        duration/minute
//        let hourRemaining:Double = floor(duration/60*minutes)
        let minutesRemaining:Double = floor(fmod(duration/minutes, minutes))
        let secondsRemaining:Double = floor(fmod(duration, minutes))

        self.timeLabel.text = String.init(format: "%0.20f:%0.20f",minutesRemaining.isNaN as CVarArg , secondsRemaining.isNaN as CVarArg)
    }
    
    

}
