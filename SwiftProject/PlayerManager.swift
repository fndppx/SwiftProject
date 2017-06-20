

//
//  PlayerManager.swift
//  SwiftProject
//
//  Created by SXJH on 2017/5/23.
//  Copyright © 2017年 SXJH. All rights reserved.
//

import UIKit
import AVFoundation
public enum QCPlaybackPlayerStatus {
    case QCPlaybackPlayerStatusUnknow
    case QCPlaybackPlayerStatusLoading
    case QCPlaybackPlayerStatusPlaying
    case QCPlaybackPlayerStatusPaused
    case QCPlaybackPlayerStatusEnd
    case QCPlaybackPlayerStatusError
}
typealias completionHandler = (_ finished:Bool) -> Void
typealias successHandler = () -> Void


public let QCPlayDidStartToPlaying: String = "QCPlayDidStartToPlaying"


@objc protocol PlayerManagerDelegate : NSObjectProtocol {
    @objc optional func playbackPlayer(player:PlayerManager)
}
class PlayerManager: NSObject {
    
    weak var delegate:PlayerManagerDelegate!
    public var url:URL?{
        willSet(newValue){
            self.reset()
            self.url = newValue
           
        }
        didSet{
            if(self.url != nil&&self.player != nil){
                let item = AVPlayerItem.init(url: self.url! as URL)
                self.player?.replaceCurrentItem(with: item)
            }
        }
    }
    var status:QCPlaybackPlayerStatus?
    var channelId:NSString?
    
    var playing:Bool=false
    
    var success:successHandler?
    
    
    
    private var player:AVPlayer?
    private var seekTime:TimeInterval?
    
    private var seeking:Bool?
    private var needToResume:Bool?

    
    
    
    class var sharedInstance: PlayerManager {
        struct Static {
            static let instance: PlayerManager = PlayerManager()
        }
        
        return Static.instance
    }
    
    
    public func seekToTime(time:TimeInterval,completionHandler:@escaping (Bool) -> ()) {
        if(self.player?.status != AVPlayerStatus.readyToPlay){
            completionHandler(false)
            return
        }
        
        let tempTime:(Int32) = (Int32)(time)
        
        var newTime = self.player?.currentItem?.currentTime()
        newTime?.value = CMTimeValue(tempTime * (newTime?.timescale)!)
        
        self.seeking = true
        self.seekTime = time
        
        self.player?.currentItem?.cancelPendingSeeks()
        self.player?.currentItem?.seek(to: newTime!, completionHandler: { (finish:Bool) in
            self.seeking = false
            if(self.isPlaying()){
                self.playSuccess {}
            }
            completionHandler(finish)
        })
        

    }
    
    public func currentTime() -> TimeInterval {

        if self.seeking!{
            return self.seekTime!
        }
        let status=self.player?.status.rawValue
        if   AVPlayerItemStatus.readyToPlay.rawValue != status {
            return TimeInterval(CGFloat.leastNormalMagnitude)
        }
        
        
        let result:Float64 = CMTimeGetSeconds((self.player?.currentItem?.currentTime())!)
        return  result
    }
    public func duration() -> TimeInterval {
        let status=self.player?.status.rawValue
        if   AVPlayerItemStatus.readyToPlay.rawValue != status {
            return TimeInterval(CGFloat.leastNormalMagnitude)
        }
        
        
        let result:Float64 = CMTimeGetSeconds((self.player?.currentItem?.duration)!)
        return  result
    }
    func isPlaying() -> Bool {
        return (self.status == QCPlaybackPlayerStatus.QCPlaybackPlayerStatusLoading) || (self.status == QCPlaybackPlayerStatus.QCPlaybackPlayerStatusPlaying)
    }
//    两种写法
//    func playSuccess(success:successHandler) {
//    func playSuccess(success:() -> ()) {

    func playSuccess(success:() -> ()) {
        if self.isPlaying(){
            return
        }
        
        let session =  AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            //多选枚举
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions(rawValue: AVAudioSessionCategoryOptions.allowBluetooth.rawValue|AVAudioSessionCategoryOptions.allowBluetooth.rawValue))
        } catch  {
            print(error)
        }
        
        self.needToResume = true
    
        if self.player===nil{
            self.player = AVPlayer.init(url: self.url!)
            self.player?.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
            self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            self.player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        }
        
        if(self.player?.currentItem?.isPlaybackLikelyToKeepUp)!{
            self.status = QCPlaybackPlayerStatus.QCPlaybackPlayerStatusLoading
        }
//        NotificationCenter
        self.player?.play()
        success()
    }
    func pause() {
        self.pauseToResume(needToResume: false)
    }
    
    func pauseToResume(needToResume:Bool) {
        self.needToResume = needToResume
        self.status = QCPlaybackPlayerStatus.QCPlaybackPlayerStatusPaused
        self.player?.pause()

//        NotificationCenter.default.post(name: <#T##NSNotification.Name#>, object: <#T##Any?#>)
    }
    func reset() {
        status = QCPlaybackPlayerStatus.QCPlaybackPlayerStatusUnknow
        needToResume = false
        if(self.player) != nil{
            self.player?.pause()
            self.player?.currentItem?.removeObserver(self, forKeyPath: "status")
            self.player?.currentItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            self.player?.currentItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            self.player = nil
        }
//        url = nil
        
//        NotificationCenter.default.post(name: NSNotification.Name, object: <#T##Any?#>)
    }
    
    
    fileprivate override init() {
        super.init()
        playing = false
        seeking = false
        needToResume = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerManager.handlePlayEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerManager.handleAudioSessionInterruption), name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PlayerManager.handlePlayEnd), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as? AVPlayerItem == self.player?.currentItem) {
            if keyPath == "status"{
                let status:AVPlayerItemStatus = (self.player?.currentItem?.status)!
                switch  status{
                case AVPlayerItemStatus.readyToPlay:
                    self.status = QCPlaybackPlayerStatus.QCPlaybackPlayerStatusPlaying
                    break
                case AVPlayerItemStatus.failed:
                    self.status = QCPlaybackPlayerStatus.QCPlaybackPlayerStatusError
                    break
                default:
                    break
                }
            }else if keyPath == "playbackBufferEmpty"{
                if (self.player?.currentItem?.isPlaybackBufferEmpty)!{
                    self.status = QCPlaybackPlayerStatus.QCPlaybackPlayerStatusLoading
                }
            }else if keyPath == "playbackLikelyToKeepUp"{
                if (self.player?.currentItem?.isPlaybackBufferEmpty==true&&self.player?.currentItem?.isPlaybackLikelyToKeepUp==true){
                    self.status = QCPlaybackPlayerStatus.QCPlaybackPlayerStatusPlaying
                }
                
            }
        }

    }
    @objc private func handlePlayEnd(notif:Notification){
        self.status = QCPlaybackPlayerStatus.QCPlaybackPlayerStatusEnd
    }

    @objc private func handleAudioSessionInterruption(notif:Notification){
        let interruptionType:AnyObject = notif.userInfo?.index(forKey: AVAudioSessionInterruptionTypeKey)! as AnyObject
        let interruptionOption:AnyObject = notif.userInfo?.index(forKey: AVAudioSessionInterruptionOptionKey)! as AnyObject

        if (self.needToResume)!{
            return
        }
        
//        switch interruptionType {
//        case AVAudioSessionInterruptionType.began.hashValue:
//            if self.isPlaying(){
//                self.pauseToResume(needToResume: true)
//            }
//            break;
//        case AVAudioSessionInterruptionType.ended.u:
//            if interruptionOption.uintValue == AVAudioSessionInterruptionOptions.shouldResume.rawValue{
//               try?AVAudioSession.sharedInstance().setActive(true)
//                if (self.player != nil){
//                    self.playSuccess{}
//                }
//                
//            }
//            break;
//        default:
//            break
//            
//        }
        
    }
    
    @objc private func handleEnterForeground(notif:Notification){
        
    }
}
