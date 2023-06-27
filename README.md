# SwiftUICalendarKit

The SwiftUI Calendar package provides a customizable calendar view layout for SwiftUI applications. It allows you to display a calendar interface with active and disabled dates, navigate between months, and select dates.

## Features
![Simulator Screen Recording - iPhone 14 Pro - 2023-06-27 at 16 14 34](https://github.com/Bereyziat-Development/SwiftUICalendarKit/assets/101000022/67458b88-2c37-4344-ab5a-bf521be865f9)


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
Enter the repository URL: https://github.com/Bereyziat-Development/SwiftUICalendarKit
Click Next and follow the remaining steps to add the package to your project.

## Usage

1. Import the necessary modules:

```swift
import SwiftUI
import SwiftUICalendarKit

```
2. Create a selectedDate variable of type Binding<Date> to hold the selected date value:

 ```swift
@State private var selectedDate = Date()

```
3. Create your SwiftUI view and use the CalendarLayout.

## Example


1. Define variables:
 ```swift
import SwiftUI
import SwiftUICalendarKit

struct ContentView: View {
    @State var selectedDate: Date
    @State var displayMonth = Date()
    @State var activeDates = [Date()]
    @State private var selectedCell: Date?
    private let calendar = Calendar(identifier: .gregorian)
    private let now = Date()
```

2. Create body:
```swift
 var body: some View {
        VStack{
            CalendarLayout(
                date: $selectedDate, calendar: calendar,
                displayMonth: displayMonth,
                activeDateRanges: nil,
                activeCell: { date in
                    Button {   selectedDate = date }
                label: {
                    Text("00")
                        .padding(8)
                        .foregroundColor(.clear)
                        .background(
                            calendar.isDate(date, inSameDayAs: selectedDate) ? Color(.red) : .white
                        )
                        .cornerRadius(25)
                        .accessibilityHidden(true)
                        .overlay(
                            Text(DateFormatter.dayFormatter.string(from: date))
                                .foregroundColor(.black)
                        )
                    
                }
                },
                disabledCell: { date in
                    Text(DateFormatter.dayFormatter.string(from: date))
                        .padding(8)
                        .foregroundColor(.secondary)
                        .background(calendar.isDate(date, inSameDayAs: now) ? Color("Blue") : .white
                        )
                        .cornerRadius(25)
                        .accessibilityHidden(true)
                    
                    
                },
                header: { date in
                    Text(DateFormatter.weekDay.string(from: date).uppercased())
                        .foregroundColor(Color(.blue))
                },
                title: { date in
                    HStack {
                        Text(LocalizedStringKey(DateFormatter.monthYear.string(from: date).capitalized))
                            .padding(.vertical)
                            .font(.headline)
                        Spacer()
                        Button {
                            withAnimation {
                                guard let newDate = calendar.date(
                                    byAdding: .month,
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
                    }
                    .padding(.bottom, 6)
                }
                
            )
            .padding()
        }
    }
 ```

3. Customize the layout and behavior of the calendar according to your needs.
4. Result:

![Simulator Screen Recording - iPhone 14 - 2023-06-27 at 16 13 48](https://github.com/Bereyziat-Development/SwiftUICalendarKit/assets/101000022/20b81fde-0b84-4eff-b39d-935c25b35342)

## License
This library is available under the MIT license. See the LICENSE file for more information.

