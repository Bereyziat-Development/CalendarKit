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
    private let showOverlay: Bool
    private let monthTitleColor: Color
    private let monthTitleFontSize: CGFloat
    private let monthTitleFontWeight: Font.Weight
    private let chevronSize: CGFloat
    private let inactiveDays: [Weekday]
    private let disabledDates: [Date]
    
    // MARK: Constants
    
    /// WARNING: The variable now is initialized upon creation of the MonthCalendarDatePicker
    /// If the MonthCalendarDatePicker would stay displayed for too long passed midnight there maybe an error
    /// in the now date (it would display yesterday)
    private let now = Date()
    private let calendar = Calendar(identifier: .gregorian)
    
    // MARK: 1) initialize with a list of date ranges

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
        activeCellFontColor: Color = .white,
        showOverlay: Bool = false,
        monthTitleColor: Color = .black,
        monthTitleFontSize: CGFloat = 24,
        monthTitleFontWeight: Font.Weight = .bold,
        chevronSize: CGFloat = 20,
        inactiveDays: [Weekday] = [],
        disabledDates: [Date] = []
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
        self.showOverlay = showOverlay
        self.monthTitleColor = monthTitleColor
        self.monthTitleFontSize = monthTitleFontSize
        self.monthTitleFontWeight = monthTitleFontWeight
        self.chevronSize = chevronSize
        self.inactiveDays = inactiveDays
        self.disabledDates = disabledDates
    }
    
    // MARK: 2) initialize with an optional startDate and an optional endDate

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
    
    // MARK: 3) initialize with one date range

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
            title: Title,
            inactiveDays: inactiveDays,
            disabledDates: disabledDates
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
        let activeCellStrokeColor = activeCellColor
            
        Button {
            selectedDate = date
        } label: {
            ZStack {
                Circle()
                    .fill(activeCellFillColor)
                    .frame(width: 40, height: 40)
                    
                if showOverlay && (isActiveCell || isDateSelected) {
                    Circle()
                        .stroke(activeCellStrokeColor, lineWidth: 2)
                }
                    
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
        HStack {
            Text(DateFormatter.monthYear.string(from: date).capitalized)
                .padding(.vertical)
                .font(.system(size: monthTitleFontSize, weight: monthTitleFontWeight))
                .foregroundColor(monthTitleColor)
            Spacer()
            Button {
                withAnimation {
                    guard let newDate = calendar.date(
                        byAdding: .month,
                        // replace with date
                        value: -1,
                        to: displayMonth
                    ) else {
                        return
                    }
                    displayMonth = newDate
                }
            } label: {
                Label(
                    title: { Text("Previous") },
                    icon: { Image(systemName: "chevron.left").font(.system(size: chevronSize)) }
                )
                
                .labelStyle(IconOnlyLabelStyle())
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
            }
            Button {
                withAnimation {
                    guard let newDate = calendar.date(
                        byAdding: .month,
                        value: 1,
                        to: displayMonth
                    ) else {
                        return
                    }
                    displayMonth = newDate
                }
            } label: {
                Label(
                    title: { Text("Next") },
                    icon: { Image(systemName: "chevron.right").font(.system(size: chevronSize)) }
                )
                .labelStyle(IconOnlyLabelStyle())
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
            }
            .buttonStyle(.plain)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 6)
    }
    
    @ViewBuilder
    private func Header(date: Date) -> some View {
        Text(DateFormatter.weekDay
            .string(from: date)
            .uppercased()
        )
        .foregroundColor(Color.black)
    }
}

// MARK: - Previews

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    struct ExampleView: View {
        @State private var selectedDate = Date()
        private let activeDateRange = DateRange(startDate: Calendar.current.date(byAdding: .weekOfYear, value: 6, to: Date())!, endDate: Calendar.current.date(byAdding: .weekOfYear, value: 12, to: Date())!)
        private let startDate = Date()
        private let endDate = Date(year: 2027, month: 7, day: 12)
        private let disabledDates = [
            Date(year: 2023, month: 11, day: 11)
        ]
        
        var body: some View {
            NavigationView {
                MonthCalendarDatePicker(
                    selectedDate: $selectedDate,
                    activeDateRanges: [DateRange(startDate: startDate, endDate: endDate)],
                    activeCellColor: .green,
                    activeRangeColor: .green.opacity(0.5),
                    disabledCellFontColor: .white,
                    activeCellFont: .caption2,
                    disabledCellFont: .caption,
                    activeStrokeColor: .yellow,
                    disabledCellFillColor: .gray,
                    activeCellFontColor: .white,
                    showOverlay: true,
                    monthTitleFontSize: 20,
                    monthTitleFontWeight: .black,
                    chevronSize: 10,
                    inactiveDays: [.tuesday],
                    disabledDates: disabledDates
                )
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
