import Foundation

public extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}

public extension DateFormatter {
    
    static let standard = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss")
    static let isoFull = DateFormatter(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSS")
    static let yearMonthDay = DateFormatter(dateFormat: "yyyy-MM-dd")
    static let dayFormatter = DateFormatter(dateFormat: "d")
    static let fullDate = DateFormatter(dateFormat: "EEEE dd MMMM yyyy")
    static  let weekDay = DateFormatter(dateFormat: "E")
    static  let monthYear = DateFormatter(dateFormat: "MMMM y")
}

