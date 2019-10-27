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
    
    var player1 = AKPlayer()
    var player2 = AKPlayer()
    
    var views = [UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
            
        AKSettings.enableLogging = true
        
        guard let clickOne = Bundle.main.url(forResource: "m1", withExtension: "mp3"),
        let clickTwo = Bundle.main.url(forResource: "m2", withExtension: "mp3")
        else {
                fatalError()
        }
            
        player1 >>> mixer
        player2 >>> mixer
        
        player1.isLooping = true
        player1.buffering = .always
        
        player2.isLooping = true
        player2.buffering = .always
        
        AudioKit.output = mixer
        do {
            try player1.load(url: clickOne)
            try player2.load(url: clickTwo)
            
            try AudioKit.start()
        } catch {
            AKLog("AudioKit did not start!")
        }
        setUpUI()
        
        player1.prepare()
        player2.prepare()
    }

    func setUpUI() {
        func startActionProblem1() ->(AKButton) -> Void {
            return { button in
            
            let now = AVAudioTime.now()
            
            self.player1.play(at: now)
            self.player2.play(at: now)
            
            }
        }
        
        func startActionProblem2() ->(AKButton) -> Void {
            return { button in
            
            let now = AVAudioTime.now() + 0.25
            
            self.player1.play(at: now)
            self.player2.play(at: now)
            }
        }
        
        addView(AKButton(title: "Problem1",
                         callback: startActionProblem1()))

        addView(AKButton(title: "Problem2",
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

