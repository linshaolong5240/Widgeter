//
//  CalendarView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/10.
//

import SwiftUI

fileprivate extension DateFormatter {
    static var month: DateFormatter {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "MMMM"
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter
    }

    static var monthAndYear: DateFormatter {
        let formatter = DateFormatter()
        //        formatter.dateFormat = "MMMM yyyy"
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return formatter
    }
}

fileprivate extension Calendar {
    func generateDates(
        inside interval: DateInterval,
        matching components: DateComponents
    ) -> [Date] {
        var dates: [Date] = []
        dates.append(interval.start)

        enumerateDates(
            startingAfter: interval.start,
            matching: components,
            matchingPolicy: .nextTime
        ) { date, _, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                } else {
                    stop = true
                }
            }
        }

        return dates
    }
}

struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let week: Date
    let hSpacing: CGFloat?
    let content: (Date) -> DateView

    init(week: Date,
         hSpacing: CGFloat? = nil,
         @ViewBuilder content: @escaping (Date) -> DateView) {
        self.week = week
        self.hSpacing = hSpacing
        self.content = content
    }

    private var days: [Date] {
        guard
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: week)
            else { return [] }
        return calendar.generateDates(
            inside: weekInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        HStack(spacing: hSpacing) {
            ForEach(days, id: \.self) { date in
                if self.calendar.isDate(self.week, equalTo: date, toGranularity: .month) {
                    self.content(date)
                } else {
                    self.content(date).hidden()
                }
            }
        }
    }
}

struct MonthView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let month: Date
    let showHeader: Bool
    let headFont: Font?
    let headPadding: CGFloat?
    let hSpacing: CGFloat?
    let vSpacing: CGFloat?
    let content: (Date) -> DateView

    init(
        month: Date,
        showHeader: Bool = true,
        headFont: Font? = nil,
        headPadding: CGFloat? = nil,
        hSpacing: CGFloat? = nil,
        vSpacing: CGFloat? = nil,
        @ViewBuilder content: @escaping (Date) -> DateView
    ) {
        self.month = month
        self.showHeader = showHeader
        self.headFont = headFont
        self.headPadding = headPadding
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        self.content = content
    }

    private var weeks: [Date] {
        guard
            let monthInterval = calendar.dateInterval(of: .month, for: month)
            else { return [] }
        return calendar.generateDates(
            inside: monthInterval,
            matching: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    private var header: some View {
        let component = calendar.component(.month, from: month)
        let formatter = component == 1 ? DateFormatter.monthAndYear : .month
        return Text(formatter.string(from: month))
            .font(headFont)
            .padding(.all, headPadding)
    }

    var body: some View {
        VStack(spacing: vSpacing) {
            if showHeader {
                header
            }
            ForEach(weeks, id: \.self) { week in
                WeekView(week: week, hSpacing: hSpacing, content: self.content)
            }
        }
    }
}

struct CalendarView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar

    let interval: DateInterval
    let content: (Date) -> DateView

    init(interval: DateInterval, @ViewBuilder content: @escaping (Date) -> DateView) {
        self.interval = interval
        self.content = content
    }

    private var months: [Date] {
        calendar.generateDates(
            inside: interval,
            matching: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ForEach(months, id: \.self) { month in
                    MonthView(month: month, content: self.content)
                }
            }
        }
    }
}

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MonthView(month: Date()) { date in
            Text(String(Calendar.current.component(.day, from: date)))
                //            .frame(width: 40, height: 40, alignment: .center)
                .frame(minWidth: 20, idealWidth: 40, maxWidth: 40, minHeight: 20, idealHeight: 40, maxHeight: 40, alignment: .center)
                .background(
                    Circle()
                        .fill(Calendar.current.isDateInToday(date) ? Color.pink : Color.blue)
                )
                .padding(.vertical, 4)
        }
//        CalendarView(interval: Calendar.current.dateInterval(of: .year, for: Date())!) { date in
//          Text(String(Calendar.current.component(.day, from: date)))
////            .frame(width: 40, height: 40, alignment: .center)
//            .frame(minWidth: 20, idealWidth: 40, maxWidth: 40, minHeight: 20, idealHeight: 40, maxHeight: 40, alignment: .center)
//            .background(Color.blue)
//            .clipShape(Circle())
//            .padding(.vertical, 4)
//        }
    }
}
#endif
