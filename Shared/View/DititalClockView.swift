//
//  DititalClockView.swift
//  Widgeter
//
//  Created by qfdev on 2021/6/10.
//

import SwiftUI

public protocol DigitalColckStyle {
    associatedtype Body : View
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = DigitalColckStyleConfiguration
}

public struct DigitalColckStyleConfiguration {
    public let date: Date
}

public struct  DefaultDigitalColckStyle: DigitalColckStyle {
    public func makeBody(configuration: Configuration) -> some View {
        let now = configuration.date
        let dateComponets = Calendar.current.dateComponents(in: .current, from: now)
        let hours = dateComponets.hour ?? 0
        let minutes = dateComponets.minute ?? 0
        let seconds = dateComponets.second ?? 0
        let components = DateComponents(hour: -hours, minute: -minutes, second: -seconds)
        let timerDate = Calendar.current.date(byAdding: components, to: now)!
        HStack(spacing: 0) {
            if hours == 0 {
                Text("00:")
            }
            if hours > 0 && hours < 10 {
                Text("0")
            }
            Text(timerDate, style: .timer)
        }
        .font(Font.custom("LESLIE", size: 36))
    }
}


struct DititalClockView: View {
    private let configuration: DigitalColckStyleConfiguration
    
    init(_ date: Date) {
        self.configuration = .init(date: date)
    }
    
    var body: some View {
        DefaultDigitalColckStyle().makeBody(configuration: configuration)
    }
}

#if DEBUG
struct DititalClockView_Previews: PreviewProvider {
    static var previews: some View {
        DititalClockView(Date())
    }
}
#endif
