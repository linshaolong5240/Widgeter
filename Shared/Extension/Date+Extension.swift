//
//  Date+Extension.swift
//  Widgeter
//
//  Created by qfdev on 2021/6/10.
//

import Foundation

extension Date {
    func nextMinuteEntryDate() -> Date {
        var currentDate = Date()
        let passSecond = Calendar.current.component(.second, from: currentDate)
        let offsetSecond: TimeInterval = TimeInterval(60 - passSecond)
        currentDate += offsetSecond
        return currentDate
    }
    func nextHour() -> Date {
        var currentDate = Date()
        let passSecond = Calendar.current.component(.second, from: currentDate)
        let passMinute = Calendar.current.component(.minute, from: currentDate)
        let offsetSecond: TimeInterval = TimeInterval(60 - passSecond)
        let offsetMinute: TimeInterval = passMinute > 0 ? TimeInterval(60 - passMinute) : 60
        currentDate += offsetSecond + (offsetMinute - 1) * 60
        return currentDate
    }
}
