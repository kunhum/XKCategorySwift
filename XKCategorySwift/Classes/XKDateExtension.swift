//
//  XKDateExtension.swift
//  XKCategorySwift
//
//  Created by Nicholas on 2020/5/29.
//

import Foundation

extension Date {
    
    public static func xk_dateToFormatterTime(intervalSince1970 interval: TimeInterval) -> String {
        
        let formatter = DateFormatter()
        /*
         设置日期格式（声明字符串里面每个数字和单词的含义）
         E:星期几
         M:月份
         d:几号(这个月的第几天)
         H:24小时制的小时
         m:分钟
         s:秒
         y:年
         */
        formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        let date = Date(timeIntervalSince1970: interval)
        let now  = Date(timeIntervalSinceNow: 0)
        let calendar = Calendar.current
        
        let unit = Set(arrayLiteral: Calendar.Component.year, .month, .day, .hour, .minute, .second)
        //计算两个日期的差值
        let components = calendar.dateComponents(unit, from: date, to: now)
        
        guard date.xk_isThisYear() else {
            //不是今年
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: date)
        }
        //昨天
        if date.xk_isYesterday() {
            formatter.dateFormat = "昨天 HH:mm"
            return formatter.string(from: date)
        }
        //今天
        if date.xk_isToday() {
            if components.hour ?? 0 >= 1 {
                return String(format: "%d小时前", components.hour ?? 0)
            }
            if components.minute ?? 0 >= 1 {
                return String(format: "%d分钟前", components.minute ?? 0)
            }
            return "刚刚"
        }
        //今年的其他时间
        formatter.dateFormat = "MM-dd HH:mm"
        return formatter.string(from: date)
    }
    //MARK: 判断是否在今年
    public func xk_isThisYear() -> Bool {
        let calendar = Calendar.current
        let dateCom  = calendar.component(.year, from: self)
        let nowCom   = calendar.component(.year, from: Date(timeIntervalSinceNow: 0))
        return dateCom == nowCom
    }
    //MARK: 判断日期是否在昨天
    public func xk_isYesterday() -> Bool {
        
        var now = Date(timeIntervalSinceNow: 0)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateStr = dateFormatter.string(from: self)
        let nowStr  = dateFormatter.string(from: now)
        
        let date = dateFormatter.date(from: dateStr)!
        now      = dateFormatter.date(from: nowStr)!
        
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.year, .month, .day]
        
        let compoments = calendar.dateComponents(unit, from: date, to: now)
        
        return compoments.year! == 0 && compoments.month! == 0 && compoments.day! == 1
    }
    //MARK: 判断是否今天
    public func xk_isToday() -> Bool {
        
        let now = Date(timeIntervalSinceNow: 0)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateStr = formatter.string(from: self)
        let nowStr  = formatter.string(from: now)
        
        return dateStr == nowStr
    }
    
}
