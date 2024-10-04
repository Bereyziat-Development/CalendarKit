//
//  Weekday.swift
//  CalendarKit
//
//  Created by Jonathan Bereyziat on 04/10/2024.
//

import Foundation

public enum Weekday: Int, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    static let weekend = [Self.saturday, Self.sunday]
    var isWeekend: Bool {
        return self == .saturday || self == .sunday
    }
}
