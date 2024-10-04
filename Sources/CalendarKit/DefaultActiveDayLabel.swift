//
//  DefaultActiveDayLabel.swift
//  CalendarKit
//
//  Created by Jonathan Bereyziat on 04/10/2024.
//

import SwiftUI

@ViewBuilder
public func defaultActiveDayLabel(date: Date) -> some View {
    ZStack {
        Circle()
            .fill(.green)
            .frame(width: 40, height: 40)
        
        Text(DateFormatter.dayFormatter.string(from: date))
            .foregroundColor(.black)
    }
}


@ViewBuilder
public func defaultCurrentDayLabel(date: Date) -> some View {
    ZStack {
        Circle()
            .fill(.green)
            .frame(width: 40, height: 40)

        Circle()
            .stroke(.green, lineWidth: 2)
        
        Text(DateFormatter.dayFormatter.string(from: date))
            .foregroundColor(.black)
    }
}

@ViewBuilder
public func defaultOutOfMonthDayLabel(date: Date) -> some View {
    ZStack {
        Circle()
            .fill(.gray)
            .frame(width: 40, height: 40)
        
        Text(DateFormatter.dayFormatter.string(from: date))
            .foregroundColor(.white)
    }
}

@ViewBuilder
public func defaultDisableDayLabel(date: Date) -> some View {
    ZStack {
        Circle()
            .fill(.gray.opacity(0.7))
            .frame(width: 40, height: 40)
        Text(DateFormatter.dayFormatter.string(from: date))
            .foregroundColor(.black)
    }
}
