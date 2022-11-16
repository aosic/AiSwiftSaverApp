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
        // 如何判断mac 刘海屏
        if #available(macOS 12.0, *) {
            if let v = NSScreen.main?.safeAreaInsets {
                print(v)
                //Optional(__C.NSEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
                //Optional(__C.NSEdgeInsets(top: 32.0, left: 0.0, bottom: 0.0, right: 0.0))
                //Optional(__C.NSEdgeInsets(top: 28.0, left: 0.0, bottom: 0.0, right: 0.0))
                //Optional(__C.NSEdgeInsets(top: 24.0, left: 0.0, bottom: 0.0, right: 0.0))
            }
        }
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
