//
//  WordLayoutAttribute.swift
//  AiSwiftSaver
//
//  Created by aoxingkui on 2022/11/13.
//

import Foundation
import AppKit

public class WordLayoutAttribute: NSObject {
    
    var flowRect = CGRect.zero
    var circleRect = CGRect.zero
    var flowTransform = CGAffineTransform.identity
    var circleTransform = CGAffineTransform.identity
    
    public var normalColor = NSColor.gray
    public var selectedColor = NSColor.white
    public var disableColor = NSColor.black
    
}
