//
//  MonthWidgetView.swift
//  Widgeter
//
//  Created by qfdev on 2021/6/10.
//
import WidgetKit
import SwiftUI

fileprivate extension WidgetFamily {
    var monthWidgetBodyFont: Font? {
        switch self {
        case .systemSmall: return .system(size: 10)
        case .systemMedium: return .system(size: 12)
        case .systemLarge: return nil
        @unknown default: return nil
        }
    }
    var monthWidgetHeadFont: Font? {
        switch self {
        case .systemSmall: return .body
        case .systemMedium: return .body
        case .systemLarge: return .title
        @unknown default: return nil
        }
    }
}

struct MonthWidgetView: View {
    @Environment(\.widgetFamily) private var family: WidgetFamily
    var date: Date

    var body: some View {
        let headPadding: CGFloat? = family == .systemLarge ? nil : 0
        let hSpacing: CGFloat? = family == .systemLarge ? nil : 2
        let vSpacing: CGFloat? = family == .systemLarge ? nil : nil
        MonthView(month: date, headFont: family.monthWidgetHeadFont, headPadding: headPadding, hSpacing: hSpacing, vSpacing: vSpacing) { date in
            Text(String(Calendar.current.component(.day, from: date)))
                .font(family.monthWidgetBodyFont)
                .frame(minWidth: 14, idealWidth: 40, maxWidth: .infinity, minHeight: 14, idealHeight: 40, maxHeight: .infinity, alignment: .center)
                .background(
                    ZStack {
                        if Calendar.current.isDateInToday(date) == true {
                            Circle().fill(Color.pink)
                        }
                    }
                )
        }
        .padding()
//        .overlay(
//            VStack {
//                switch family {
//                case .systemSmall: Text("systemSmall")
//                case .systemMedium: Text("systemMedium")
//                case .systemLarge: Text("systemLarge")
//                default: Text("default")
//                }
//            }
//        )
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
