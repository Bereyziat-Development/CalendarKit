import SwiftUI

///CalendarLayout allows you to create your own personalized view of calendar.
///If  no activeDateRange is provided all dates of the calendar are set as active
public struct CalendarLayout<Day: View, Header: View, Title: View, Trailing: View>: View {
    @Binding var date: Date
    
    public  let calendar: Calendar
    public   let displayMonth: Date
    public let activeDateRanges: [DateRange]?
    public let activeCell: (Date) -> Day?
    public let disabledCell: (Date) -> Trailing
    public let header: (Date) -> Header
    public let title: (Date) -> Title
    public var startDate: Date?
    public var endDate: Date?
    
    public init(date: Binding<Date>,
                calendar: Calendar,
                displayMonth: Date,
                activeDateRanges: [DateRange]?,
                activeCell: @escaping (Date) -> Day,
                disabledCell: @escaping (Date) -> Trailing,
                header: @escaping (Date) -> Header,
                title: @escaping (Date) -> Title) {
        self._date = date
        self.calendar = calendar
        self.displayMonth = displayMonth
        self.activeDateRanges = activeDateRanges
        self.activeCell = activeCell
        self.disabledCell = disabledCell
        self.header = header
        self.title = title
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
                        activeCell(date)
                    } else {
                        disabledCell(date)
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
        lhs.date == rhs.date &&
        lhs.displayMonth == rhs.displayMonth
    }
}

public extension CalendarLayout {
    private func isInMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: month, toGranularity: .month)
    }
    private func isActive(_ date: Date) -> Bool {
        guard let activeDateRanges else { return isInMonth(date) }
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
