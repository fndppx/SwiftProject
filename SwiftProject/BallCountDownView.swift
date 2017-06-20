
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
        let minutesRemaining:Double = floor(fmod(duration/minutes, minutes))
        let secondsRemaining:Double = floor(fmod(duration, minutes))

        //小数点前面位数 和保留几位小数
        let textContent = String.init(format: "%02.0f:%02.0f", arguments: [minutesRemaining.isNaN ? 0 : minutesRemaining,secondsRemaining.isNaN ? 0 : secondsRemaining])
        print(textContent)
        self.timeLabel.text = textContent
    }
    
    

}
