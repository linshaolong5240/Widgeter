//
//  CornerCalendarView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/7/2.
//

import SwiftUI

fileprivate extension Date {
    func EEString(localized: Bool = false) -> String {
        let formatter = DateFormatter()
        if localized {
            formatter.dateFormat = "EE"
        }else {
            formatter.setLocalizedDateFormatFromTemplate("EE")
        }
        return formatter.string(from: self)
    }
    
    var yesterday: Date { return self.dayBefore }
    var tomorrow:  Date { return self.dayAfter }
    
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}

struct CornerCalendarView: View {
    let date: Date
    
    init(_ date: Date) {
        self.date = date
    }
    var body: some View {
        HStack {
            Text("\(date.yesterday.EEString())")
            Text("\(date.EEString())")
            Text("\(date.tomorrow.EEString())")
        }
    }
}

struct CornerCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CornerCalendarView(Date())
    }
}
