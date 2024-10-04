//
//  Date.swift
//  CalendarKit
//
//  Created by Jonathan Bereyziat on 29/06/2023.
//

import Foundation

public extension Date {
    init(year: Int, month: Int, day: Int) {
        let calendar = Constants.calendar
        let dateComponents = DateComponents(year: year, month: month, day: day)
        self = calendar.date(from: dateComponents)!
    }
    
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}
