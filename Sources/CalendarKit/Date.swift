//
//  Date.swift
//  CalendarKit
//
//  Created by Jonathan Bereyziat on 29/06/2023.
//

import Foundation

public extension Date {
    init(year: Int, month: Int, day: Int) {
        let calendar = Constant.Time.calendar
        var dateComponents = DateComponents(year: year, month: month, day: day)
        self = calendar.date(from: dateComponents)!
    }
}
