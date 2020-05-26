//
//  UIDate+Extension.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/17.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

extension Date {
    
    static func getAgeForDateStr(birth: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let birthday = formatter.date(from: birth)
        let currentDateStr = formatter.string(from: Date())
        let currentDate = formatter.date(from: currentDateStr)
        let timeInterval: TimeInterval = (currentDate?.timeIntervalSince(birthday!))!
        let age = timeInterval/(3600*24*365)
        return Int(age)
    }
    
    ///相隔多少天
    static func getDaysFromBeginDayToEndDay(beginDateStr: String, endDateStr: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.date(from: beginDateStr)
        let endDate = formatter.date(from: endDateStr)
        guard currentDate != nil, endDate != nil else {
            return -1
        }
        let components = Calendar.current.dateComponents([.day], from: currentDate!, to: endDate!)
        if let day = components.day {
            return day
        }
        return -1
    }
    
    /// 比较某个时间 在当前时间 前 还是 后
    static func isExpired(time:String) -> Bool {
        let dformatters = DateFormatter.init()
        dformatters.locale = Locale.current
        dformatters.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = Date()
        let timeZone = NSTimeZone.system
        let inteval = timeZone.secondsFromGMT(for: now)
        DLog("timeInteval = \(inteval)")
        //let dateString1 = "2017-07-06 13:40"
        let dateLocal = now.addingTimeInterval(TimeInterval(inteval))
        let date1 = dformatters.date(from: time)?.addingTimeInterval(TimeInterval(inteval))
        DLog("date1 == \(date1) dateNowLocal = \(dateLocal) dateNow = \(now) ")
        if date1?.compare(dateLocal) == ComparisonResult.orderedAscending {
            //print("date1 is earlier")
            return false
        } else if date1?.compare(dateLocal) == ComparisonResult.orderedDescending {
            //print("date2 is earlier")
            return true
        } else if date1?.compare(dateLocal) == ComparisonResult.orderedSame {
            //print("Same date!!!")
        }
        return true
    }
    
    ///获取当前日期的多少年的日期
    static func getCurrentDayBeforeYear(year: Int) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        var maxDateStr = ""
        var maxYears = ""
        
        if let currentYear = Int(formatter.string(from: Date())) {
            let maxYear =  currentYear - 18
            DLog("===\(maxYear)")
            maxYears = "\(maxYear)"
            maxDateStr.append(contentsOf: maxYears)
        }
        maxDateStr.append(contentsOf: "-")
        
        formatter.dateFormat = "MM"
        let currentMonth = formatter.string(from: Date())
        maxDateStr.append(contentsOf: currentMonth)
        maxDateStr.append(contentsOf: "-")
        formatter.dateFormat = "dd"
        let currentDay = formatter.string(from: Date())
        maxDateStr.append(contentsOf: currentDay)
        
        formatter.dateFormat = "yyyy-MM-dd"
        if let maxDate = formatter.date(from: maxDateStr) {
            //            datePicker.maximumDate = maxDate
            return maxDate
        }
        return Date()
    }
    
    static func getLocalDateWithDateStr(dateStr: String) -> Date {
        let timeFormatter = DateFormatter()
        // 注意的是下面给格式的时候,里面一定要和字符串里面的统一
        // 比如:   dateStr为2017-07-24 17:38:27   那么必须设置成yyyy-MM-dd HH:mm:ss, 如果你设置成yyyy--MM--dd HH:mm:ss, 那么date就是null, 这是需要注意的
        timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = timeFormatter.date(from: dateStr) {
            return date
        }
        
        return Date()
    }
    
    //根据字符串获取当地Date
    static func getLocalDateWithString(dateStr:String) -> Date {
        let formatter = DateFormatter.init();
        formatter.dateFormat = "yyyy-MM-dd";
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0);
        let date = formatter.date(from: dateStr);
        return date!;
    }
    //根据系统Date获取当地Date
    static  func getLocalWithDate(date:Date) -> Date {
        let zone = NSTimeZone.system;
        let interval = zone.secondsFromGMT(for: date);
        let localDate = date.addingTimeInterval(TimeInterval(interval));
        return localDate;
    }
    
    //根据系统Date获取当地Date字符串
    static func getLocalDateStrWithDate(date:Date) -> String {
        let formatter = DateFormatter.init();
        formatter.dateFormat = "yyyy-MM-dd";
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0);
        let dateStr = formatter.string(from: date);
        return dateStr;
    }
}
