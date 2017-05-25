

//
//  PlayerManager.swift
//  SwiftProject
//
//  Created by SXJH on 2017/5/23.
//  Copyright © 2017年 SXJH. All rights reserved.
//

import UIKit
import AVFoundation
enum QCPlaybackPlayerStatus {
    case QCPlaybackPlayerStatusUnknow
    case QCPlaybackPlayerStatusLoading
    case QCPlaybackPlayerStatusPlaying
    case QCPlaybackPlayerStatusPaused
    case QCPlaybackPlayerStatusEnd
    case QCPlaybackPlayerStatusError
}
typealias completionHandler = (_ finished:Bool) -> Void
typealias successHandler = () -> Void

@objc protocol PlayerManagerDelegate : NSObjectProtocol {
    @objc optional func playbackPlayer(player:PlayerManager)
}
class PlayerManager: NSObject {
    
    weak var delegate:PlayerManagerDelegate!
    var url:NSURL?
    var status:QCPlaybackPlayerStatus?
    var channelId:NSString?
    
    var playing:Bool=false
    
    
    private var player:AVPlayer?
    
    
    class var sharedInstance: PlayerManager {
        struct Static {
            static let instance: PlayerManager = PlayerManager()
        }
        
        return Static.instance
    }
    
    
    public func seekToTime(time:TimeInterval,completionHandler:completionHandler?) {
        
    }
    public func currentTime(time:TimeInterval) -> TimeInterval {
        return 0
    }
    public func duration(time:TimeInterval) -> TimeInterval {
        return 1
    }
    func isPlaying(isPlaying:Bool) -> Bool {
        return true
    }
    
    func playSuccess(success:successHandler) {
        
    }
    func pause() {
        
    }
    func reset() {
        
    }
    
    
    fileprivate override init() {
        
        
    }

}
