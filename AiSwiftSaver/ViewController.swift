//
//  ViewController.swift
//  AiSwiftSaver
//
//  Created by aoxingkui on 2022/11/13.
//

import Cocoa

class ViewController: NSViewController {
    
    var wordClock = WordClock()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = .black
        view.addSubview(wordClock)
        let minV = min(view.frame.width, view.frame.height)
        let maxV = max(view.frame.width, view.frame.height)
        let t = CGRect(x: (maxV - minV) / 2.0, y: 0, width: minV, height: minV)
        wordClock.frame = t
        wordClock.startClock()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    


}
