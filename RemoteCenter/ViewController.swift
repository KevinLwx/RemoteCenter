//
//  ViewController.swift
//  RemoteCenter
//
//  Created by huang on 16/8/6.
//  Copyright © 2016年 huang. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateStepper: UIStepper!
    
    override func viewDidLoad() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let player = appDelegate.player
        
        player?.addObserver(self, forKeyPath: "rate", options: [.Initial, .New], context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if let player = appDelegate.player {
            rateLabel.text = "\(player.rate)"
            rateStepper.value = Double(player.rate)
        }
    }
    
    @IBAction func onValueChanged(sender: UIStepper) {
       
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.player!.rate = Float(sender.value)
    }

}

