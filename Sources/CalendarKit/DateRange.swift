import Foundation

public struct DateRange {
    // A date range without a startDate and/or and endDate correspond to an open interval
    public var startDate: Date? = nil
    public var endDate: Date? = nil
    
    public init(startDate: Date? = nil, endDate: Date? = nil) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    public func contains(_ date: Date) -> Bool {
        var isWithinRange = true
        let calendar = Calendar(identifier: .gregorian)
        let dateToCheckComponents = calendar.dateComponents([.year, .month, .day], from: date)
        guard let dateToCheckWithoutTime = calendar.date(from: dateToCheckComponents) else { fatalError("Not a valid date") }
        
        if let startDate {
            let startDateComponents = calendar.dateComponents([.year, .month, .day], from: startDate)
            guard let startDateWithoutTime = calendar.date(from: startDateComponents) else { fatalError("Not a valid date") }
            isWithinRange = startDateWithoutTime <= dateToCheckWithoutTime
        }
        
        if let endDate {
            let endDateComponents = calendar.dateComponents([.year, .month, .day], from: endDate)
            guard let endDateWithoutTime = calendar.date(from: endDateComponents) else { fatalError("Not a valid date") }
            isWithinRange = isWithinRange && (dateToCheckWithoutTime <= endDateWithoutTime)
        }
        
        return isWithinRange
    }
}

public struct Constant {
    public struct Time {
        public static let _2DaysInSeconds: Double = 172_800
        public static let _2MonthInSeconds: Double = 5_260_000
        public static let calendar = Calendar(identifier: .gregorian)
    }
}

