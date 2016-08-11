//
//  AppDelegate.swift
//  RemoteCenter
//
//  Created by huang on 16/8/6.
//  Copyright © 2016年 huang. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var player: AVPlayer?
    
    func updateNowPlayingInfo() {
        let center = MPNowPlayingInfoCenter.defaultCenter()
        center.nowPlayingInfo = [MPMediaItemPropertyTitle: "\(player!.rate)"]
    }
    
    func alwaysSuccess(command: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return .Success
    }
    
    func DoAction(action: (Void -> Void)) {
        action()
    }
    
    func translateToHandler(action: (Void -> Void)) -> (MPRemoteCommandEvent -> MPRemoteCommandHandlerStatus) {
        
        func alwaysSuccess(command: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
            DoAction(action)
            return .Success
        }
        
        return alwaysSuccess
    }
    
    // actual logic to perform media commands
    func onNextTrack() { self.player?.rate *= 1.1 }
    func onPreviousTrack() { self.player?.rate *= 0.9 }
    func onToggle() { self.player?.rate > 0 ? self.player!.pause() : self.player?.play() }
    func onPlay() { self.player!.play() }
    func onPause() { self.player?.pause() }
    func onSkipForward() {
        self.player?.currentItem?.seekToTime(CMTimeAdd((self.player?.currentTime())!, CMTimeMakeWithSeconds(10, 1)))
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        updateNowPlayingInfo()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        player = AVPlayer(URL: NSBundle.mainBundle().URLForResource("ESLPod1231.mp3", withExtension: nil)!)
        player?.addObserver(self, forKeyPath: "rate", options: [.Initial, .New], context: nil)
        
        player!.play()
        
        let commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        
        // wire all commands with controller's functions

        // center button
        commandCenter.togglePlayPauseCommand.addTargetWithHandler(translateToHandler(onToggle))
        commandCenter.playCommand.addTargetWithHandler(translateToHandler(onPlay))
        commandCenter.pauseCommand.addTargetWithHandler(translateToHandler(onPause))

        // right button
        //commandCenter.skipForwardCommand.addTargetWithHandler(translateToHandler(onSkipForward))
        commandCenter.nextTrackCommand.addTargetWithHandler(translateToHandler(onNextTrack))

        // commands in menu
        //commandCenter.skipBackwardCommand.addTargetWithHandler(alwaysSuccess)
        commandCenter.previousTrackCommand.addTargetWithHandler(translateToHandler(onPreviousTrack))

        // commands in menu
        if false {
            commandCenter.likeCommand.addTargetWithHandler(alwaysSuccess)
            commandCenter.dislikeCommand.addTargetWithHandler(alwaysSuccess)
            commandCenter.bookmarkCommand.addTargetWithHandler(alwaysSuccess)
        }
        
        commandCenter.enableLanguageOptionCommand.addTargetWithHandler(alwaysSuccess)
        commandCenter.disableLanguageOptionCommand.addTargetWithHandler(alwaysSuccess)
        
        commandCenter.ratingCommand.addTargetWithHandler(alwaysSuccess)
        commandCenter.changePlaybackRateCommand.addTargetWithHandler(alwaysSuccess)
        
        
        updateNowPlayingInfo()
        
        return true
    }
}