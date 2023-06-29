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
    private let color: Color
    
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
        color: Color = .green
    ) {
        _selectedDate = selectedDate
        _displayMonth = State(initialValue: now)
        self.activeDateRanges = activeDateRanges
        self.color = color
    }
    
    // MARK: initialize with an optional startDate and an optional endDate

    public init(
        selectedDate: Binding<Date>,
        startDate: Date? = nil,
        endDate: Date? = nil,
        color: Color = .green
    ) {
        self.init(
            selectedDate: selectedDate,
            activeDateRange: DateRange(startDate: startDate, endDate: endDate),
            color: color
        )
    }
    
    // MARK: initialize with one date range

    public init(
        selectedDate: Binding<Date>,
        activeDateRange: DateRange,
        color: Color = .green
    ) {
        self.init(
            selectedDate: selectedDate,
            activeDateRanges: [activeDateRange],
            color: color
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
            displayMonth = selectedDate
        }
    }
    
    @ViewBuilder
    private func ActiveCell(date: Date) -> some View {
        Button {
            selectedDate = date
        } label: {
            ZStack {
                Circle()
                    .fill(calendar.isDate(date, inSameDayAs: selectedDate) ? color : color.opacity(0.5))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Circle().stroke(
                        calendar.isDate(date, inSameDayAs: now) ? .orange : color,
                        lineWidth: 2))
                Text(DateFormatter.dayFormatter.string(from: date))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func DisabledCell(date: Date) -> some View {
        ZStack {
            Circle()
                .fill(.clear)
                .overlay(Circle().stroke(calendar.isDate(date, inSameDayAs: now) ? .orange : .clear, lineWidth: 2))
                .frame(width: 40, height: 40)
            Text(DateFormatter.dayFormatter.string(from: date))
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private func Title(date: Date) -> some View {
        HStack {
            Text(DateFormatter.monthYear.string(from: date).capitalized)
                .padding(.vertical)
                .font(.headline)
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
                    icon: { Image(systemName: "chevron.left") }
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
                    icon: { Image(systemName: "chevron.right") }
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
        .foregroundColor(Color("LightGrey"))
    }
}

// MARK: - Previews

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    struct ExampleView: View {
        @State private var selectedDate = Date()
        private let now = Date()
        
        var body: some View {
            NavigationView {
                MonthCalendarDatePicker(
                    selectedDate: $selectedDate,
                    startDate: now,
                    endDate: now.advanced(by: Constant.Time._2MonthInSeconds),
                    color: .orange
                )
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
