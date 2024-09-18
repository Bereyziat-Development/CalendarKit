import SwiftUI

/// CalendarLayout allows you to create your own personalized view of calendar.
/// If  no activeDateRange is provided all dates of the calendar are set as active
///
///

public enum Weekday: Int, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    static let weekend = [Self.saturday, Self.sunday]
    var isWeekend: Bool {
        return self == .saturday || self == .sunday
    }
}

public struct CalendarLayout<ActiveDay: View, Header: View, Title: View, DisabledDay: View, OutOfMonthDay :View>: View {
    @Binding var selectedDate: Date
    
    public let calendar: Calendar
    public let displayMonth: Date
    public let activeDateRanges: [DateRange]?
    public let activeDay: (Date) -> ActiveDay
    public let disabledDay: (Date) -> DisabledDay
    
    public let outOfRangeCellView: (Date) -> OutOfMonthDay
    public let header: (Date) -> Header
    public let title: (Date) -> Title
    public var startDate: Date?
    public var endDate: Date?
    public var inactiveDays: [Weekday]
    public var disabledDates: [Date]
    public var selectedDateRange: [DateRange]?


    
    
    public init(
        selectedDate: Binding<Date>,
        calendar: Calendar = Calendar(identifier: .gregorian),
        displayMonth: Date = Date(),
        activeDateRanges: [DateRange]? = nil,
        activeDay: @escaping (Date) -> ActiveDay,
        disableDay: @escaping (Date) -> DisabledDay,
        outOfMonthDay: @escaping (Date) -> OutOfMonthDay,
        header: @escaping (Date) -> Header,
        title: @escaping (Date) -> Title,
        inactiveDays: [Weekday] = [],
        disabledDates: [Date] = []
    ) {
        self._selectedDate = selectedDate
        self.calendar = calendar
        self.displayMonth = displayMonth
        self.activeDateRanges = activeDateRanges
        self.activeDay = activeDay
        self.disabledDay = disableDay
        self.header = header
        self.title = title
        self.inactiveDays = inactiveDays
        self.disabledDates = disabledDates
        self.outOfRangeCellView = outOfMonthDay
    }
    
    // MARK: 1) initialize with an optional startDate and an optional endDate
    
    init(
        selectedDate: Binding<Date>,
        calendar: Calendar = Calendar(identifier: .gregorian),
        displayMonth: Date = Date(),
        startDate: Date? = nil,
        endDate: Date? = nil,
        activeDay: @escaping (Date) -> ActiveDay,
        disabledDay: @escaping (Date) -> DisabledDay,
        outOfMonthDay: @escaping (Date) -> OutOfMonthDay,
        header: @escaping (Date) -> Header,
        title: @escaping (Date) -> Title,
        inactiveDays: [Weekday] = []
    ) {
        self.init(
            selectedDate: selectedDate,
            calendar: calendar,
            displayMonth: displayMonth,
            activeDateRange: DateRange(startDate: startDate, endDate: endDate),
            activeDay: activeDay,
            disabledDay: disabledDay, 
            outOfMonthDay: outOfMonthDay,
            header: header,
            title: title,
            inactiveDays: inactiveDays
        )
    }
    
    // MARK: 2) initialize with a single date range
    
    init(
        selectedDate: Binding<Date>,
        calendar: Calendar = Calendar(identifier: .gregorian),
        displayMonth: Date = Date(),
        activeDateRange: DateRange,
        activeDay: @escaping (Date) -> ActiveDay,
        disabledDay: @escaping (Date) -> DisabledDay,
        outOfMonthDay: @escaping (Date) -> OutOfMonthDay,
        header: @escaping (Date) -> Header,
        title: @escaping (Date) -> Title,
        inactiveDays: [Weekday] = []
    ) {
        self.init(
            selectedDate: selectedDate,
            calendar: calendar,
            displayMonth: displayMonth,
            activeDateRanges: [activeDateRange],
            activeDay: activeDay,
            disableDay: disabledDay, 
            outOfMonthDay: outOfMonthDay,
            header: header,
            title: title,
            inactiveDays: inactiveDays
        )
    }
    
    // MARK: 3) initialize with a disabledDates
    
    init(
        selectedDate: Binding<Date>,
        calendar: Calendar = Calendar(identifier: .gregorian),
        displayMonth: Date = Date(),
        activeDateRange: DateRange,
        activeDay: @escaping (Date) -> ActiveDay,
        disabledDay: @escaping (Date) -> DisabledDay,
        outOfMonthDay: @escaping (Date) -> OutOfMonthDay,
        header: @escaping (Date) -> Header,
        title: @escaping (Date) -> Title,
        disabledDates: [Date] = [],
        inactiveDays: [Weekday] = []
    ) {
        self._selectedDate = selectedDate
        self.calendar = calendar
        self.displayMonth = displayMonth
        self.activeDateRanges = [activeDateRange]
        self.activeDay = activeDay
        self.disabledDay = disabledDay
        self.header = header
        self.title = title
        self.disabledDates = disabledDates
        self.inactiveDays = inactiveDays
        self.outOfRangeCellView = outOfMonthDay
    }
    
    // MARK: 4) initialize with a weekendsActive parameter
    
    public init(
        selectedDate: Binding<Date>,
        calendar: Calendar = Calendar(identifier: .gregorian),
        displayMonth: Date = Date(),
        activeDateRanges: [DateRange]? = nil,
        activeDay: @escaping (Date) -> ActiveDay,
        disabledDay: @escaping (Date) -> DisabledDay,
        outOfMonthDay: @escaping (Date) -> OutOfMonthDay,
        header: @escaping (Date) -> Header,
        title: @escaping (Date) -> Title,
        disabledDates: [Date] = [],
        isWeekendsActive: Bool = true
    ) {
        self._selectedDate = selectedDate
        self.calendar = calendar
        self.displayMonth = displayMonth
        self.activeDateRanges = activeDateRanges
        self.activeDay = activeDay
        self.disabledDay = disabledDay
        self.outOfRangeCellView = outOfMonthDay
        self.header = header
        self.title = title
        self.disabledDates = disabledDates
        self.inactiveDays = isWeekendsActive ? Weekday.weekend : []
    }
    
    // MARK: 5) initialize with a selectable date range
    public init(
        selectedDate: Binding<Date>,
        calendar: Calendar = Calendar(identifier: .gregorian),
        displayMonth: Date = Date(),
        activeDateRanges: [DateRange]? = nil,
        activeDay: @escaping (Date) -> ActiveDay,
        disabledDay: @escaping (Date) -> DisabledDay,
        outOfMonthDay: @escaping (Date) -> OutOfMonthDay,
        header: @escaping (Date) -> Header,
        title: @escaping (Date) -> Title,
        inactiveDays: [Weekday] = [],
        disabledDates: [Date] = [],
        selectedDateRange: [DateRange]? = nil
    ) {
        self._selectedDate = selectedDate
        self.calendar = calendar
        self.displayMonth = displayMonth
        self.activeDateRanges = activeDateRanges
        self.activeDay = activeDay
        self.disabledDay = disabledDay
        self.outOfRangeCellView = outOfMonthDay
        self.header = header
        self.title = title
        self.inactiveDays = inactiveDays
        self.disabledDates = disabledDates
        self.selectedDateRange = selectedDateRange
    }
    // Constants
    public let daysInWeek = 7
    public var month: Date {
        displayMonth.startOfMonth(using: calendar)
    }
    
    public var days: [Date] {
        makeDays()
    }
    
    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: daysInWeek)) {
            Section(header: title(month)) {
                ForEach(days.prefix(daysInWeek), id: \.self, content: header)
                ForEach(days, id: \.self) { date in
                    if isActive(date) {
                        outOfRangeCellView(date)
                        activeDay(date)
                    } else {
                        disabledDay(date)
                    }
                }
            }
        }
    }
}

// MARK: - Conformances

extension CalendarLayout: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.calendar == rhs.calendar &&
        lhs.selectedDate == rhs.selectedDate &&
        lhs.displayMonth == rhs.displayMonth
    }
}

public extension CalendarLayout {
    private func isInMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: month, toGranularity: .month)
    }
    
    private func isDateDisabled(_ date: Date) -> Bool {
        return disabledDates.contains { Calendar.current.isDate($0, inSameDayAs: date) }
    }
    
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

// MARK: - Helpers

public extension CalendarLayout {
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

public extension Calendar {
    func generateDates(
        for dateInterval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates = [dateInterval.start]
        enumerateDates(
            startingAfter: dateInterval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            guard let date = date else { return }
            guard date < dateInterval.end else {
                stop = true
                return
            }
            dates.append(date)
        }
        return dates
    }
    
    func generateDays(for dateInterval: DateInterval) -> [Date] {
        generateDates(
            for: dateInterval,
            matching: dateComponents([.hour, .minute, .second], from: dateInterval.start)
        )
    }
}

public extension Date {
    func startOfMonth(using calendar: Calendar) -> Date {
        calendar.date(
            from: calendar.dateComponents([.year, .month], from: self)
        ) ?? self
    }
}
