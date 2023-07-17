//
//  MonthCalendarDatePicker.swift
//
//
//  Created and maintained by Bereyziat Development on 29/06/2023.
//

import SwiftUI

public struct MonthCalendarDatePicker: View {
    @Binding private var selectedDate: Date
    @State private var displayMonth: Date
    
    private let activeDateRanges: [DateRange]?
    private let activeCellColor: Color
    private let activeRangeColor: Color?
    private let disabledCellColor: Color?
    private let activeCellFont: Font
    private let disabledCellFont: Font
    private let activeStrokeColor: Color
    private let disabledCellFillColor: Color
    private let activeCellFontColor: Color
    
    // MARK: Constants
    
    /// WARNING: The variable now is initialized upon creation of the DisposalCalendar
    /// If the CalendarDisposal View will stay displayed for too long at midnight there maybe an error
    /// in the now date (it will display yesterday)
    private let now = Date()
    private let calendar = Calendar(identifier: .gregorian)
    
    // MARK: initialize with a list of date ranges
    
    public init(
        selectedDate: Binding<Date>,
        activeDateRanges: [DateRange],
        activeCellColor: Color = .green,
        activeRangeColor: Color = .green,
        disabledCellFontColor: Color = .white,
        activeCellFont: Font = .system(size: 16),
        disabledCellFont: Font = .system(size: 16),
        activeStrokeColor: Color = .orange,
        disabledCellFillColor: Color = .clear,
        activeCellFontColor: Color = .white
    ) {
        _selectedDate = selectedDate
        _displayMonth = State(initialValue: now)
        self.activeDateRanges = activeDateRanges
        self.activeCellColor = activeCellColor
        self.activeRangeColor = activeRangeColor
        self.disabledCellColor = disabledCellFontColor
        self.activeCellFont = activeCellFont
        self.disabledCellFont = disabledCellFont
        self.activeStrokeColor = activeStrokeColor
        self.disabledCellFillColor = disabledCellFillColor
        self.activeCellFontColor = activeCellFontColor
    }
    
    // MARK: initialize with an optional startDate and an optional endDate
    
    public init(
        selectedDate: Binding<Date>,
        startDate: Date? = nil,
        endDate: Date? = nil,
        activeCellColor: Color = .green,
        activeCellFont: Font = .system(size: 16),
        disabledCellFont: Font = .system(size: 16)
    ) {
        self.init(
            selectedDate: selectedDate,
            activeDateRanges: [DateRange(startDate: startDate, endDate: endDate)],
            activeCellColor: activeCellColor,
            activeCellFont: activeCellFont,
            disabledCellFont: disabledCellFont
        )
    }
    
    // MARK: initialize with one date range
    
    public init(
        selectedDate: Binding<Date>,
        activeDateRange: DateRange,
        color: Color = .green,
        activeCellFont: Font = .system(size: 16),
        disabledCellFont: Font = .system(size: 16)
    ) {
        self.init(
            selectedDate: selectedDate,
            activeDateRanges: [activeDateRange],
            activeCellColor: color,
            activeCellFont: activeCellFont,
            disabledCellFont: disabledCellFont
        )
    }
    
    public var body: some View {
        CalendarLayout(
            selectedDate: $selectedDate,
            calendar: calendar,
            displayMonth: displayMonth,
            activeDateRanges: activeDateRanges,
            activeCell: ActiveCell,
            disabledCell: DisabledCell,
            header: Header,
            title: Title
        )
        .equatable()
        .onAppear {
            displayMonth = $selectedDate.wrappedValue
        }
        
    }
    
    @ViewBuilder
    private func ActiveCell(date: Date) -> some View {
        let isDateSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isActiveCell = calendar.isDate(date, inSameDayAs: now)
        let isActiveRange = activeDateRanges?.contains { $0.contains(date) } ?? false
        let activeCellFillColor = isDateSelected ? activeCellColor : isActiveRange ? activeRangeColor ?? activeCellColor.opacity(0.5) : activeCellColor.opacity(0.5)
        let activeCellStrokeColor = isActiveCell ? activeStrokeColor : activeCellColor
        
        Button {
            selectedDate = date
        } label: {
            ZStack {
                Circle()
                    .fill(activeCellFillColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle().stroke(activeCellStrokeColor, lineWidth: 2)
                    )
                Text(DateFormatter.dayFormatter.string(from: date))
                    .font(activeCellFont)
                    .foregroundColor(activeCellFontColor)
            }
        }
        .buttonStyle(.plain)
    }
    
    
    @ViewBuilder
    private func DisabledCell(date: Date) -> some View {
        ZStack {
            Circle()
                .fill(disabledCellFillColor)
                .overlay(Circle().stroke(calendar.isDate(date, inSameDayAs: now) ? .orange : .clear, lineWidth: 2))
                .frame(width: 40, height: 40)
            Text(DateFormatter.dayFormatter.string(from: date))
                .font(disabledCellFont)
                .foregroundColor(disabledCellColor)
        }
    }
    
    @ViewBuilder
    private func Title(date: Date) -> some View {
        // Implementation of Title view omitted for brevity
    }
    
    @ViewBuilder
    private func Header(date: Date) -> some View {
        // Implementation of Header view omitted for brevity
    }
}


// MARK: - Previews

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    struct ExampleView: View {
        @State private var selectedDate = Date()
        private let activeDateRange = DateRange(startDate: Date(), endDate: Calendar.current.date(byAdding: .weekOfYear, value: 2, to: Date())!)
        private let now = Date()
        private let twoWeeksFromNow = Calendar.current.date(byAdding: .weekOfYear, value: 2, to: Date())!
        
        
        var body: some View {
            NavigationView {
                MonthCalendarDatePicker(selectedDate: $selectedDate, activeDateRanges: [DateRange(startDate: Date(), endDate: twoWeeksFromNow)], activeCellColor: .green, activeRangeColor: .green.opacity(0.5), disabledCellFontColor: .white, activeCellFont: .caption2, disabledCellFont: .caption, activeStrokeColor: .yellow, disabledCellFillColor: .gray, activeCellFontColor: .white)
                    .padding()
            }
        }
    }
    
    static var previews: some View {
        ExampleView()
            .previewDisplayName("iPhone 13")
            .previewDevice("iPhone 13")
        ExampleView()
            .previewDisplayName("iPhone SE")
            .previewDevice("iPhone SE (3rd generation)")
    }
}
#endif
