//
//  WordClockView.swift
//  AiSwiftSaver
//
//  Created by aoxingkui on 2022/11/13.
//

import Foundation
import AppKit
import Dispatch
import DispatchIntrospection

public protocol WordDataSource: NSObjectProtocol {
    
    func numberOfWordClockSections() -> Int
    func numberItems(in section: Int) -> Int
    func word(at section: Int, in index: Int) -> String
    func wordItem(for index: Int, of section: Int) -> NSView
    func currentFormatDateTime() -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, weekDay: Int, monthDays: Int, formateDate: String)
    
}

public class WordClock: NSView {
    
    var monthArray: [String] = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
    var dayArray = [  "一号",  "二号",  "三号",  "四号",  "五号",  "六号",  "七号",  "八号",  "九号",  "十号",  "十一号",  "十二号",  "十三号",  "十四号",  "十五号",  "十六号",  "十七号",  "十八号",  "十九号",  "二十号",  "二十一号",  "二十二号",  "二十三号",  "二十四号",  "二十五号",  "二十六号",  "二十七号",  "二十八号",  "二十九号",  "三十号",  "三十一号"]
    var weekArray = [  "周日",   "周一",  "周二",  "周三",  "周四",  "周五",  "周六"]
    var hourArray = [  "一点",  "二点",  "三点",  "四点",  "五点",  "六点",  "七点",  "八点",  "九点",  "十点",  "十一点",  "十二点",  "十三点",  "十四点",  "十五点",  "十六点",  "十七点",  "十八点",  "十九点",  "二十点",  "二十一点",  "二十二点",  "二十三点",  "零点"]
    var minuteArray = [   "一分",  "二分",  "三分",  "四分",  "五分",  "六分",  "七分",  "八分",  "九分",  "十分",  "十一分",  "十二分",  "十三分",  "十四分",  "十五分",  "十六分",  "十七分",  "十八分",  "十九分",  "二十分",  "二十一分",  "二十二分",  "二十三分",  "二十四分",  "二十五分",  "二十六分",  "二十七分",  "二十八分",  "二十九分",  "三十分",  "三十一分",  "三十二分",  "三十三分",  "三十四分",  "三十五分",  "三十六分",  "三十七分",  "三十八分",  "三十九分",  "四十分",  "四十一分",  "四十二分",  "四十三分",  "四十四分",  "四十五分",  "四十六分",  "四十七分",  "四十八分",  "四十九分",  "五十分",  "五十一分",  "五十二分",  "五十三分",  "五十四分",  "五十五分",  "五十六分",  "五十七分",  "五十八分",  "五十九分",  "零分"]
    var secondArray = [  "一秒",  "二秒",  "三秒",  "四秒",  "五秒",  "六秒",  "七秒",  "八秒",  "九秒",  "十秒",  "十一秒",  "十二秒",  "十三秒",  "十四秒",  "十五秒",  "十六秒",  "十七秒",  "十八秒",  "十九秒",  "二十秒",  "二十一秒",  "二十二秒",  "二十三秒",  "二十四秒",  "二十五秒",  "二十六秒",  "二十七秒",  "二十八秒",  "二十九秒",  "三十秒",  "三十一秒",  "三十二秒",  "三十三秒",  "三十四秒",  "三十五秒",  "三十六秒",  "三十七秒",  "三十八秒",  "三十九秒",  "四十秒",  "四十一秒",  "四十二秒",  "四十三秒",  "四十四秒",  "四十五秒",  "四十六秒",  "四十七秒",  "四十八秒",  "四十九秒",  "五十秒",  "五十一秒",  "五十二秒",  "五十三秒",  "五十四秒",  "五十五秒",  "五十六秒",  "五十七秒",  "五十八秒",  "五十九秒",  "零秒"]
    
    lazy var sourceArray = [monthArray, dayArray, weekArray, hourArray, minuteArray, secondArray]
    
    lazy var dateFormatter = {
        let v = DateFormatter()
        v.dateFormat = "yyyy\r\nHH:mm:ss"
        return v
    } ()
    
    lazy var yearLabel: NSTextField = {
        let v = NSTextField()
        v.backgroundColor = .clear
        v.maximumNumberOfLines = 0
        v.alignment = .center
        v.font = .systemFont(ofSize: 24)
        v.textColor = .white
        v.isEditable = false
        v.isBordered = false
        return v
    }()
    
    var needsReload = false
    
    var cachedCells: [IndexPath: NSView] = [:]
    
    var lastRect = CGRect.zero
    
    public weak var dataSource: WordDataSource? {
        didSet {
            _setNeedsReload()
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startClock() {
        timer.resume()
    }
    
    private func reloadData() {
        
    }
    
    private func _setNeedsReload() {
        needsReload = true
    }
    
    private func _reloadDataIfNeeded() {
        if needsReload {
            reloadData()
        }
    }
    
    private var currentTimeTup: (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, weekDay: Int, monthDays: Int, formateDate: String) = (2019, 1, 1, 1, 1, 1, 0, 31, "")
    
    private(set) lazy var timer: DispatchSourceTimer = {
        let v = DispatchSource.makeTimerSource(flags: [], queue: .main)
        v.schedule(deadline: .now(), repeating: 1, leeway: .milliseconds(1))
        v.setEventHandler {
            [weak self] in
            self?.checkClock()
        }
        return v
    }()

    private func startTimer() {
    }
    
    private func stopTimer() {
        timer.cancel()
    }
    
    private func resumeTimer() {
        timer.resume()
    }
    
    public override func layout() {
        super.layout()
        _reloadDataIfNeeded()
        _layoutWordItems()
    }
    
    func checkClock() {
        guard let rDelegate = dataSource else {
            return
        }
        let tuple = rDelegate.currentFormatDateTime()
        self.yearLabel.stringValue = tuple.formateDate
        currentTimeTup.monthDays = tuple.monthDays
        animation(at: 5, value: tuple.second)
        animation(at: 4, value: tuple.minute)
        animation(at: 3, value: tuple.hour)
        animation(at: 2, value: tuple.weekDay)
        animation(at: 1, value: tuple.day)
        animation(at: 0, value: tuple.month)
    }
    
    func _layoutWordItems() {
        cachedCells.values.forEach { v in
            v.removeFromSuperview()
        }
        guard !bounds.isEmpty else { return }
        guard let rDataSource = dataSource else { return }
        cachedCells.removeAll()
        let sections = rDataSource.numberOfWordClockSections()
        for i in stride(from: 0, to: sections, by: 1) {
            let rows = rDataSource.numberItems(in: i)
            for j in stride(from: 0, to: rows, by: 1) {
                let rowView = rDataSource.wordItem(for: j, of: i)
                addSubview(rowView)
                rowView.layer?.anchorPoint = CGPoint(x: 0, y: 0.5)
                if let label = rowView as? WordItem {
                    let textValue = rDataSource.word(at: i, in: j)
                    label.stringValue = textValue
                    let att = generateAttribute(totalSections: sections, section: i, index: j, totalRows: rows, wordText: textValue)
                    label.wordAttribute = att
                    label.frame = att.circleRect
                    label.layer?.transform = CATransform3DMakeAffineTransform(att.circleTransform)
                }
                cachedCells.updateValue(rowView, forKey: IndexPath(item: j, section: i))
            }
        }
        yearLabel.frame = CGRect(x: (bounds.size.width - 120) / 2.0, y: (bounds.size.height - 70) / 2.0, width: 120, height: 70)
        addSubview(yearLabel)
    }
    
    func generateAttribute(totalSections: Int, section: Int, index: Int, totalRows: Int, wordText: String) -> WordLayoutAttribute {
        let att = WordLayoutAttribute()
        if section == 0, index == 0 {
            lastRect = .zero
        }
        let midx = bounds.midX
        let midy = bounds.midY
        let supWidth = bounds.width - 10
        var width = CGFloat(section + 1) / CGFloat(totalSections) * supWidth / 2.0
        if section == 0 || section == 1 {
            width += 1.0 / CGFloat(totalSections) * supWidth / 2.0 / 2.0
        }
        let font = NSFont.systemFont(ofSize: 8)
        let size = wordText.boundingRect(with: CGSize(width: 100, height: 20), options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font : font], context: nil).size
        var flowx = lastRect.origin.x
        var flowy = lastRect.origin.y
        if lastRect.origin.x + lastRect.size.width + size.width < bounds.size.width {
            flowx += lastRect.size.width
        } else {
            flowx = 0
            flowy += 20
        }
        att.flowRect = CGRect(x: flowx, y: flowy, width: size.width, height: 20)
        lastRect = att.flowRect
        
        att.flowTransform = .identity
        att.circleRect = CGRect(x: midx, y: midy, width: width, height: 20)
        att.circleTransform = CGAffineTransformMakeRotation(_degreeToRatin(CGFloat(360 * index) / CGFloat(totalRows)))
        return att
    }
    
    func _degreeToRatin(_ x: CGFloat) -> CGFloat {
        return CGFloat.pi * x / 180.0
    }
    
    func animation(at section: Int, value: Int) {
        switch section {
        case 0:
            currentTimeTup.month = value
        case 1:
            currentTimeTup.day = value
        case 2:
            currentTimeTup.weekDay = value
        case 3:
            currentTimeTup.hour = value
        case 4:
            currentTimeTup.minute = value
        case 5:
            currentTimeTup.second = value
        default:
            fatalError()
        }
        guard let rdataSource = dataSource else {
            return
        }
        let totalRows = rdataSource.numberItems(in: section)
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            for i in stride(from: 0, to: totalRows, by: 1) {
                if let v = cachedCells[IndexPath(item: i, section: section)] as? WordItem {
                    v.wordAttribute?.circleTransform = .identity
                    v.wordAttribute?.circleTransform = CGAffineTransformMakeRotation(_degreeToRatin(CGFloat(360 * i) / CGFloat(totalRows)) - _degreeToRatin(CGFloat(value - 1) * 360.0 / CGFloat(totalRows)))
                    v.layer?.transform = CATransform3DMakeAffineTransform(v.wordAttribute!.circleTransform)
                    if i == value - 1 {
                        v.textColor = v.wordAttribute?.selectedColor
                    } else {
                        v.textColor = v.wordAttribute?.normalColor
                    }
                    if (section == 4 || section == 5) &&
                        value == 0 &&
                        i == 59 {
                        v.textColor = v.wordAttribute?.selectedColor
                    }
                    if section == 1, i >= currentTimeTup.monthDays {
                        v.textColor = v.wordAttribute?.disableColor
                    }
                }
            }
        } completionHandler: {
            
        }
    }

}

extension WordClock: WordDataSource {
    
    public func numberOfWordClockSections() -> Int {
        sourceArray.count
    }
    
    public func numberItems(in section: Int) -> Int {
        sourceArray[section].count
    }
    
    public func word(at section: Int, in index: Int) -> String {
        sourceArray[section][index]
    }
    
    public func wordItem(for index: Int, of section: Int) -> NSView {
        let v = WordItem()
        v.wantsLayer = true
        v.drawsBackground = true
        v.backgroundColor = .clear
        v.alignment = .right
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white
        v.isEditable = false
        v.isBordered = false
        return v
    }
    
    public func currentFormatDateTime() -> (year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, weekDay: Int, monthDays: Int, formateDate: String) {
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let compt = cal.dateComponents(in: TimeZone.current, from: date)
        let year = compt.year!
        let month = compt.month!
        let day = compt.day!
        let hour = compt.hour!
        let minute = compt.minute!
        let second = compt.second!
        let weekday = compt.weekday!
        let txt = dateFormatter.string(from: date)
        let numberOfDays = cal.range(of: Calendar.Component.day, in: Calendar.Component.month, for: date)!.count
        return (year: year, month: month, day: day, hour: hour, minute: minute, second: second, weekDay: weekday, monthDays: numberOfDays, formateDate: txt)
    }
    
}
