//
//  MonthWidgetView.swift
//  Widgeter
//
//  Created by qfdev on 2021/6/10.
//
import WidgetKit
import SwiftUI

struct MonthWidgetView: View {
    @Environment(\.widgetFamily) private var family: WidgetFamily
    var date: Date

    var body: some View {
        let headFont: Font = family == .systemLarge ? .title : .body
        let headPadding: CGFloat? = family == .systemLarge ? nil : 5
        let hSpacing: CGFloat? = family == .systemLarge ? nil : 5
        MonthView(month: date, headFont: headFont, headPadding: headPadding, hSpacing: hSpacing) { date in
            Text(String(Calendar.current.component(.day, from: date)))
                .font(.system(size: 10))
                .frame(minWidth: 15, idealWidth: 40, maxWidth: .infinity, minHeight: 15, idealHeight: 40, maxHeight: .infinity, alignment: .center)
                .background(
                    ZStack {
                        if Calendar.current.isDateInToday(date) == true {
                            Circle().fill(Color.pink)
                        }
                    }
                )
        }
        .padding()
    }
}

struct MonthWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonthWidgetView(date: Date())
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            MonthWidgetView(date: Date())
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            MonthWidgetView(date: Date())
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
