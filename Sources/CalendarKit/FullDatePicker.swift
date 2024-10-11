//
//  FullDatePicker.swift
//
//
//  Created and maintained by Bereyziat Development on 29/06/2023.
//  Refactored on 22/09/2024
//

import SwiftUI


// Custom ViewModifier to apply a global font
struct GlobalFontModifier: ViewModifier {
    var size: CGFloat
    var weight: Font.Weight = .regular

    func body(content: Content) -> some View {
        content.font(.custom("Zapfino", size: size).weight(weight))
    }
}

extension View {
    // Extension to make applying the global font easy
    func globalFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.modifier(GlobalFontModifier(size: size, weight: weight))
    }
}

//TODO: put back the font and sized that were the right one from previous design and just allow to change the fonct familly
public let defaultFont: Font = .system(size: 14)
public let defaultAccentColor: Color = .green


public struct FullDatePicker<ActiveDayLabel: View, CurrentDayLabel: View, DisabledDayLabel: View, OutOfMonthDayLabel: View>: View {
    @Binding private var selectedDate: Date
    @State private var displayMonth: Date
    @State private var rangeSelection: (startDate: Date?, endDate: Date?)
    @ViewBuilder private let activeDayLabel: (Date) -> ActiveDayLabel
    @ViewBuilder private let currentDayLabel: (Date) -> CurrentDayLabel
    @ViewBuilder private let disabledDayLabel: (Date) -> DisabledDayLabel
    @ViewBuilder private let outOfMonthDayLabel: (Date) -> OutOfMonthDayLabel
    private let activeDateRanges: [DateRange]?
    private let font: Font
    private let fontName: String?
    private let accentColor: Color
    private let inactiveDays: [Weekday]
    private let disabledDates: [Date]
    private let selectedDateRange: [DateRange]?
    
    // MARK: Constants
    
    private let now = Date()
    private let calendar = Constants.calendar
    
    // Constants
    private let daysInWeek = 7
    private var month: Date {
        displayMonth.startOfMonth(using: calendar)
    }
    
    private var days: [Date] {
        makeDays()
    }
    
    
    //TODO: Enable the init back and allow the different date options
    public init(
        selectedDate: Binding<Date>,
        displayMonth: Date = Date(),
        activeDateRanges: [DateRange]? = nil,
        @ViewBuilder activeDayLabel: @escaping (Date) -> ActiveDayLabel = defaultActiveDayLabel,
        @ViewBuilder currentDayLabel: @escaping (Date) -> CurrentDayLabel = defaultCurrentDayLabel,
        @ViewBuilder disabledDayLabel: @escaping (Date) -> DisabledDayLabel = defaultDisableDayLabel,
        @ViewBuilder outOfMonthDayLabel: @escaping (Date) -> OutOfMonthDayLabel = defaultOutOfMonthDayLabel,
        //        outOfMonthDay: @escaping (Date) -> OutOfMonthDayLabel,
        inactiveDays: [Weekday] = [],
        disabledDates: [Date] = [],
        font: Font = defaultFont,
        accentColor: Color = defaultAccentColor,
        selectedDateRange: [DateRange]? = nil
    ) {
        self._selectedDate = selectedDate
        self.displayMonth = displayMonth
        self.activeDateRanges = activeDateRanges
        self.activeDayLabel = activeDayLabel
        self.currentDayLabel = currentDayLabel
        self.disabledDayLabel = disabledDayLabel
        self.outOfMonthDayLabel = outOfMonthDayLabel
        self.inactiveDays = inactiveDays
        self.disabledDates = disabledDates
        
        self.font = font
        //TODO: to add as an attribute of the init
        self.fontName = nil
        self.accentColor = accentColor
        self.selectedDateRange = selectedDateRange
    }
    
    func customFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        //TODO: define if using fixedSize or not
        if let fontName {
            Font.custom(fontName, fixedSize: size).weight(weight)
        } else {
            Font.system(size: size, weight: weight)
        }
        
    }
    
    // MARK: 1) initialize with an optional startDate and an optional endDate
    
    //    init(
    //        selectedDate: Binding<Date>,
    //        displayMonth: Date = Date(),
    //        startDate: Date? = nil,
    //        endDate: Date? = nil,
    //        activeDay: @escaping (Date) -> ActiveDayLabel,
    //        disabledDay: @escaping (Date) -> DisabledDayLabel,
    //        outOfMonthDay: @escaping (Date) -> OutOfMonthDayLabel,
    //        inactiveDays: [Weekday] = []
    //    ) {
    //        self.init(
    //            selectedDate: selectedDate,
    //            displayMonth: displayMonth,
    //            activeDateRange: DateRange(startDate: startDate, endDate: endDate),
    //            activeDay: activeDay,
    //            disabledDay: disabledDay,
    //            outOfMonthDay: outOfMonthDay,
    //            inactiveDays: inactiveDays
    //        )
    //    }
    //
    //    // MARK: 2) initialize with a single date range
    //
    //    init(
    //        selectedDate: Binding<Date>,
    //        displayMonth: Date = Date(),
    //        activeDateRange: DateRange,
    //        activeDay: @escaping (Date) -> ActiveDayLabel,
    //        disabledDay: @escaping (Date) -> DisabledDayLabel,
    //        outOfMonthDay: @escaping (Date) -> OutOfMonthDayLabel,
    //        inactiveDays: [Weekday] = []
    //    ) {
    //        self.init(
    //            selectedDate: selectedDate,
    //            displayMonth: displayMonth,
    //            activeDateRanges: [activeDateRange],
    //            activeDay: activeDay,
    //            disableDay: disabledDay,
    //            outOfMonthDay: outOfMonthDay,
    //            inactiveDays: inactiveDays
    //        )
    //    }
    //
    //    // MARK: 3) initialize with a disabledDates
    //
    //    init(
    //        selectedDate: Binding<Date>,
    //        displayMonth: Date = Date(),
    //        activeDateRange: DateRange,
    //        activeDay: @escaping (Date) -> ActiveDayLabel,
    //        disabledDay: @escaping (Date) -> DisabledDayLabel,
    //        outOfMonthDay: @escaping (Date) -> OutOfMonthDayLabel,
    //        disabledDates: [Date] = [],
    //        inactiveDays: [Weekday] = []
    //    ) {
    //        self._selectedDate = selectedDate
    //        self.displayMonth = displayMonth
    //        self.activeDateRanges = [activeDateRange]
    //        self.activeDay = activeDay
    //        self.disabledDay = disabledDay
    //        self.disabledDates = disabledDates
    //        self.inactiveDays = inactiveDays
    //        self.outOfMonthDay = outOfMonthDay
    //    }
    //
    //    // MARK: 4) initialize with a weekendsActive parameter
    //
    //    public init(
    //        selectedDate: Binding<Date>,
    //        displayMonth: Date = Date(),
    //        activeDateRanges: [DateRange]? = nil,
    //        activeDay: @escaping (Date) -> ActiveDayLabel,
    //        disabledDay: @escaping (Date) -> DisabledDayLabel,
    //        outOfMonthDay: @escaping (Date) -> OutOfMonthDayLabel,
    //        disabledDates: [Date] = [],
    //        isWeekendsActive: Bool = true
    //    ) {
    //        self._selectedDate = selectedDate
    //        self.displayMonth = displayMonth
    //        self.activeDateRanges = activeDateRanges
    //        self.activeDay = activeDay
    //        self.disabledDay = disabledDay
    //        self.outOfMonthDay = outOfMonthDay
    //        self.disabledDates = disabledDates
    //        self.inactiveDays = isWeekendsActive ? Weekday.weekend : []
    //    }
    //
    //    // MARK: 5) initialize with a selectable date range
    //    public init(
    //        selectedDate: Binding<Date>,
    //        displayMonth: Date = Date(),
    //        activeDateRanges: [DateRange]? = nil,
    //        activeDay: @escaping (Date) -> ActiveDayLabel,
    //        disabledDay: @escaping (Date) -> DisabledDayLabel,
    //        outOfMonthDay: @escaping (Date) -> OutOfMonthDayLabel,
    //        inactiveDays: [Weekday] = [],
    //        disabledDates: [Date] = [],
    //        selectedDateRange: [DateRange]? = nil
    //    ) {
    //        self._selectedDate = selectedDate
    //        self.displayMonth = displayMonth
    //        self.activeDateRanges = activeDateRanges
    //        self.activeDay = activeDay
    //        self.disabledDay = disabledDay
    //        self.outOfMonthDay = outOfMonthDay
    //        self.inactiveDays = inactiveDays
    //        self.disabledDates = disabledDates
    //        self.selectedDateRange = selectedDateRange
    //    }
    //
    
    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
            Section(header: Title(month)) {
                ForEach(days.prefix(daysInWeek), id: \.self, content: Header)
                ForEach(days, id: \.self) { date in
                    dayButton(date)
                }
            }
        }
        .onAppear {
            displayMonth = selectedDate
        }
    }
    
    @ViewBuilder
    private func dayButton(_ date: Date) -> some View {
        let isInCurrentMonth = calendar.isDate(date, equalTo: displayMonth, toGranularity: .month)
        
        Button {
            if isInCurrentMonth {
                handleDateSelection(date)
            } else {
                if date < displayMonth {
                    goToPreviousMonth()
                } else {
                    goToNextMonth()
                }
            }
        } label: {
            if calendar.isDate(date, inSameDayAs: now) {
                currentDayLabel(date)
            } else if isInCurrentMonth {
                if isActive(date) {
                    activeDayLabel(date)
                } else {
                    disabledDayLabel(date)
                }
            } else {
                outOfMonthDayLabel(date)
            }
            
        }
        .buttonStyle(.plain)
    }
    
    //DisabledCell with behaviour for changing displayed month when user taps on part of new/ previous month (outOfRangeDates).
    @ViewBuilder
    private func DisabledCellLabel(date: Date) -> some View {
        ZStack {
            Circle()
                .fill(.gray)
                .overlay(Circle().stroke(calendar.isDate(date, inSameDayAs: now) ? .orange : .clear, lineWidth: 2))
                .frame(width: 40, height: 40)
            Text(DateFormatter.dayFormatter.string(from: date))
                .foregroundColor(.black)
        }
    }
    
    @ViewBuilder
    private func Header(_ date: Date) -> some View {
        Text(DateFormatter.weekDay
            .string(from: date)
            .uppercased()
        )
    }
    
    @ViewBuilder
    private func Title(_ date: Date) -> some View {
        HStack {
            Text(DateFormatter.monthYear.string(from: date).capitalized)
                .padding(.vertical)
                .globalFont(size: 30)
            
            Spacer()
            
            Button {
                goToPreviousMonth()
            } label: {
                
                Image(systemName: "chevron.left")
                    .labelStyle(IconOnlyLabelStyle())
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity)
                
            }
            Button {
                goToNextMonth()
            } label: {
                Image(systemName: "chevron.right")
                    .labelStyle(IconOnlyLabelStyle())
                    .padding(.horizontal)
                    .frame(maxHeight: .infinity)
            }
            .buttonStyle(.plain)
            
        }
        .buttonStyle(.plain)
        .padding(.bottom, 6)
    }
    
    private func goToNextMonth() {
        guard let newDate = calendar.date(
            byAdding: .month,
            value: 1,
            to: displayMonth
        ) else {
            return
        }
        displayMonth = newDate
    }
    
    private func goToPreviousMonth() {
        guard let newDate = calendar.date(
            byAdding: .month,
            value: -1,
            to: displayMonth
        ) else {
            return
        }
        displayMonth = newDate
    }
    
    private func handleDateSelection(_ date: Date) {
        if selectedDateRange == nil {
            selectedDate = date
        } else {
            if let startDate = rangeSelection.startDate {
                if rangeSelection.endDate != nil {
                    rangeSelection = (date, nil)
                } else if date >= startDate {
                    rangeSelection.endDate = date
                } else {
                    rangeSelection = (date, nil)
                }
            } else {
                rangeSelection.startDate = date
            }
        }
    }
}

public extension FullDatePicker {
    private func isInMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: month, toGranularity: .month)
    }
    
    private func isDateDisabled(_ date: Date) -> Bool {
        disabledDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
    }
    
    //TODO: modify this to handle a more granular approach
    private func isActive(_ date: Date) -> Bool {
        guard let activeDateRanges = activeDateRanges else { return isInMonth(date) }
        
        // Check if the date is in disabledDates
        if disabledDates.contains(where: { Calendar.current.isDate($0, inSameDayAs: date) }) {
            return false
        }
        
        // Check if Weekdays are active and if the date is a weekend
        let currentDay = Weekday(rawValue: Calendar.current.component(.weekday, from: date))
        if let currentDay, inactiveDays.contains(currentDay) {
            return false
        }
        
        for dateRange in activeDateRanges {
            if isInMonth(date) && dateRange.contains(date) {
                return true
            }
        }
        return false
    }
}

public extension FullDatePicker {
    func makeDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let monthLastWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else {
            return []
        }
        
        let dateInterval = DateInterval(start: monthFirstWeek.start, end: monthLastWeek.end)
        return calendar.generateDays(for: dateInterval)
    }
}


fileprivate struct ExampleView: View {
    @State private var selectedDate = Date()
    
    private var activeDateRange: CalendarKit.DateRange {
        let now = Date()
        let numberOfDays = 90
        let calendar = Constants.calendar
        let startDate = calendar.date(byAdding: .day, value: -numberOfDays, to: now)!
        let endDate = calendar.date(byAdding: .day, value: +numberOfDays, to: now)!
        return CalendarKit.DateRange(startDate: startDate, endDate: endDate)
    }
    private let startDate = Date()
    private let endDate = Date(year: 2027, month: 7, day: 12)
    private let disabledDates = [
        Date(year: 2023, month: 11, day: 11)
    ]
    
    var body: some View {
        VStack {
            Text("Selected date: \(selectedDate.formatted())")
            FullDatePicker(
                selectedDate: $selectedDate,
                activeDateRanges: [activeDateRange],
                inactiveDays: [.tuesday],
                disabledDates: disabledDates
            )
        }
        .environment(\.font, Font.custom("Zapfino", size: 10))
    }
}


#Preview("Default FullDatePicker") {
    ExampleView()
}
