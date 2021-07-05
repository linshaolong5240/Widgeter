//
//  CornerCalendarView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/7/2.
//

import SwiftUI

fileprivate extension Corner {
    var dayAngle: Angle {
        switch self {
        case .topLeading:       return .degrees(-45)
        case .topTrailing:      return .degrees(45)
        case .bottomLeading:    return .degrees(45)
        case .bottomTrailing:   return .degrees(-45)
        }
    }
}

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
    
    func dString(localized: Bool = false) -> String {
        let formatter = DateFormatter()
        if localized {
            formatter.dateFormat = "d"
        }else {
            formatter.setLocalizedDateFormatFromTemplate("d")
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
    let position: Corner
    
    init(_ date: Date,
         position: Corner) {
        self.date = date
        self.position = position
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                ZStack {
                    VStack {
                        if position.isBottom {
                            Spacer()
                        }
                        Text("\(date.yesterday.dString())")
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.1)
                            .frame(width: minLength / 10, height: minLength / 15)
                            .background(Color.gray)
                            .cornerRadius(minLength / 70)
                        if position.isTop {
                            Spacer()
                        }
                    }
                    .rotationEffect(position.isTop ? position.dayAngle - .degrees(15) : position.dayAngle + .degrees(15))
                    VStack {
                        if position.isBottom {
                            Spacer()
                        }
                        Text("\(date.dString())")
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.1)
                            .frame(width: minLength / 10, height: minLength / 15)
                            .background(Color.pink)
                            .cornerRadius(minLength / 70)
                        if position.isTop {
                            Spacer()
                        }
                    }
                    .rotationEffect(position.dayAngle)
                    VStack {
                        if position.isBottom {
                            Spacer()
                        }
                        Text("\(date.tomorrow.dString())")
                            .fontWeight(.bold)
                            .minimumScaleFactor(0.1)
                            .frame(width: minLength / 10, height: minLength / 15)
                            .background(Color.gray)
                            .cornerRadius(minLength / 70)
                        if position.isTop {
                            Spacer()
                        }
                    }
                    .rotationEffect(position.isTop ? position.dayAngle + .degrees(15) : position.dayAngle - .degrees(15))
                    ZStack(alignment: position.cornerAlignment) {
                        Color.clear
                        Text("\(date.EEString().uppercased())")
                            .fontWeight(.bold)
                            .font(.system(size: minLength / 16))
                            .lineLimit(1)
                            .minimumScaleFactor(0.1)
                            .frame(width: minLength / 7, height: minLength / 7)
                            .rotationEffect(position.cornerTextAngle)
                    }
                    .frame(width: minLength * 0.95, height: minLength * 0.95)
                }
                .frame(width: minLength, height: minLength)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

struct CornerCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CornerCalendarView(Date(), position: .topLeading)
            CornerCalendarView(Date(), position: .topTrailing)
            CornerCalendarView(Date(), position: .bottomLeading)
            CornerCalendarView(Date(), position: .bottomTrailing)
        }
    }
}
