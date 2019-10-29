//
//  ViewController.swift
//  AKPlayerProblems
//
//  Created by Artem Popkov on 27/10/2019.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import AudioKitUI
import AudioKit

class ViewController: UIViewController {
    
    var mixer = AKMixer()
    var player1mp3 = AKPlayer()
    var player2mp3 = AKPlayer()
    
    var player1 = AKPlayer()
    var player2 = AKPlayer()
    var views = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        AKSettings.enableLogging = true
        
        guard let clickOneMp3 = Bundle.main.url(forResource: "m1MP3", withExtension: "mp3"),
        let clickTwoMp3 = Bundle.main.url(forResource: "m2MP3", withExtension: "mp3")
        else {
                fatalError()
        }
        
        guard let clickOne = Bundle.main.url(forResource: "m1", withExtension: "wav"),
        let clickTwo = Bundle.main.url(forResource: "m2", withExtension: "wav")
        else {
                fatalError()
        }
        
        player1mp3 >>> mixer
        player2mp3 >>> mixer
            
        player1 >>> mixer
        player2 >>> mixer
        
        player1.isLooping = true
        player1.buffering = .always
        
        player2.isLooping = true
        player2.buffering = .always
        
        player1mp3.isLooping = true
        player1mp3.buffering = .always
        
        player2mp3.isLooping = true
        player2mp3.buffering = .always
        
        AudioKit.output = mixer
        do {
            try player1mp3.load(url: clickOneMp3)
            try player2mp3.load(url: clickTwoMp3)
            
            try player1.load(url: clickOne)
            try player2.load(url: clickTwo)
            
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        setUpUI()
        
        player1mp3.prepare()
        player2mp3.prepare()
        
        player1.prepare()
        player2.prepare()
    }

    func setUpUI() {
        func startActionProblem1() ->(AKButton) -> Void {
            return { button in
                
                if self.player1mp3.isPlaying {
                    self.player1mp3.stop()
                    self.player2mp3.stop()
                } else {
                    let now = AVAudioTime.now() + 0.25
                    
                    self.player1mp3.play(at: now)
                    self.player2mp3.play(at: now)
                }
            
            
            
            }
        }
        
        func startActionProblem2() ->(AKButton) -> Void {
            return { button in
            
            if self.player1.isPlaying {
                self.player1.stop()
                self.player2.stop()
            } else {
                let now = AVAudioTime.now() + 0.25
                
                self.player1.play(at: now)
                self.player2.play(at: now)
            }
            }
        }
        
        addView(AKButton(title: "play mp3",
                         callback: startActionProblem1()))

        addView(AKButton(title: "play wav",
                         callback: startActionProblem2()))
    }
    
    func addView(_ view: UIView) {
        views.append(view)
        self.view.addSubview(view)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let inset = CGFloat(10)
        let elemHeight = CGFloat(80)

        var nextFrame = CGRect(x: inset,
                               y: (view.frame.size.height - (elemHeight) * CGFloat(view.subviews.count)) / 2.0,
                               width: view.frame.size.width - inset * 2,
                               height: elemHeight)

        for view in views {
            view.frame = nextFrame
            AKLog("frame " + String(describing: nextFrame.origin.y))
            nextFrame = nextFrame.offsetBy(dx: 0, dy: nextFrame.size.height + inset)
        }
    }
}

