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
    private let headerColor: Color
    private let headerFont: Font
    private let chevronSize: CGFloat
    private let chevronColor: Color
    private let daysColor: Color
    private let daysFont: Font
    private let inactiveDays: [Weekday]
    private let disabledDates: [Date]
    
    
    // MARK: Constants
    
    /// WARNING: The variable now is initialized upon creation of the DisposalCalendar
    /// If the CalendarDisposal View will stay displayed for too long at midnight there maybe an error
    /// in the now date (it will display yesterday)
    private let now = Date()
    private let calendar = Calendar(identifier: .gregorian)
    
    // MARK: initialize with a list of date ranges
    //1
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
        headerColor: Color = .black,
        headerFont: Font = .caption,
        chevronSize: CGFloat = 20,
        chevronColor: Color  = .gray,
        daysColor: Color = .black,
        daysFont: Font = .caption,
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
        self.headerColor = headerColor
        self.headerFont = headerFont
        self.chevronSize = chevronSize
        self.chevronColor = chevronColor
        self.daysColor = daysColor
        self.daysFont = daysFont
        self.inactiveDays = inactiveDays
        self.disabledDates = disabledDates
    }
    
    // MARK: initialize with an optional startDate and an optional endDate
    //2
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
    //3
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
                .font(headerFont)
                .foregroundColor(headerColor)
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
                    icon: { Image(systemName: "chevron.left").font(.system(size: chevronSize)).foregroundColor(chevronColor) }
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
                    icon: { Image(systemName: "chevron.right").font(.system(size: chevronSize)).foregroundColor(chevronColor) }
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
        .font(daysFont)
        .foregroundColor(daysColor)
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
                MonthCalendarDatePicker(selectedDate: $selectedDate, activeDateRanges: [DateRange(startDate: startDate, endDate: endDate)], activeCellColor: .green, activeRangeColor: .green.opacity(0.5), disabledCellFontColor: .white, activeCellFont: .caption2, disabledCellFont: .caption, activeStrokeColor: .yellow, disabledCellFillColor: .gray, activeCellFontColor: .white, showOverlay: true, headerFont: .title, chevronSize: 10, chevronColor: .blue, daysColor: .black, inactiveDays: [.tuesday], disabledDates: disabledDates)
                

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
