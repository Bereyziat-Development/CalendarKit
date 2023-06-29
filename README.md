# CalendarKit

The SwiftUI Calendar package provides a customizable calendar view layout for SwiftUI applications. It allows you to display a calendar interface with active and disabled dates, navigate between months, and select dates.

## Features
![Simulator Screen Recording - iPhone 14 Pro - 2023-06-27 at 16 14 34](https://github.com/Bereyziat-Development/CalendarKit/assets/101000022/67458b88-2c37-4344-ab5a-bf521be865f9)


Display a calendar interface with month navigation
Customize active and disabled dates
Select and highlight a date
Customize selectable range of dates.

## Requirements
iOS 14 or later
Swift 5.0 or later

### Installation
Swift Package Manager
You can install the SwiftUI Calendar package using Swift Package Manager. Follow these steps:

In Xcode, open your project.
Go to File > Swift Packages > Add Package Dependency.
Enter the repository URL: https://github.com/Bereyziat-Development/CalendarKit
Click Next and follow the remaining steps to add the package to your project.

## Usage

1. Import the necessary modules:

```swift
import SwiftUI
import CalendarKit

```
2. Create a selectedDate variable of type Binding<Date> to hold the selected date value:

 ```swift
@State private var selectedDate = Date()

```
3. Create your SwiftUI view and use the CalendarLayout.

## Ready To Use example
1. If you just plan on having a native DatePicker that supports DateRange you can simply use the MonthCalendarDatePicker in your project.
This View also serves as an example for this library.
2. If you have more adavanced need you can use the CalendarLayout and customise it according to your needs.
3. Result:

![Simulator Screen Recording - iPhone 14 - 2023-06-27 at 16 13 48](https://github.com/Bereyziat-Development/CalendarKit/assets/101000022/20b81fde-0b84-4eff-b39d-935c25b35342)

## License
This library is available under the MIT license. See the LICENSE file for more information.

