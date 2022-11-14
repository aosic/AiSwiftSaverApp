//
//  AiSSaver.swift
//  AiSSaver
//
//  Created by aoxingkui on 2022/11/13.
//

import ScreenSaver

public class AiSSaver: ScreenSaverView {
    
    var wordClock = WordClock()

    public override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        animationTimeInterval = 1.0 / 30.0
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor
        addSubview(wordClock)
        let minV = min(frame.width, frame.height)
        let maxV = max(frame.width, frame.height)
        let t = CGRect(x: (maxV - minV) / 2.0, y: 0, width: minV, height: minV)
        wordClock.frame = t
        wordClock.startClock()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func startAnimation() {
        super.startAnimation()
    }
    
    public override func stopAnimation() {
        super.stopAnimation()
    }
    
    public override func animateOneFrame() {
        
    }
    
    public override var hasConfigureSheet: Bool {
        return false
    }
    
    public override var configureSheet: NSWindow? {
        return nil
    }
    
}
