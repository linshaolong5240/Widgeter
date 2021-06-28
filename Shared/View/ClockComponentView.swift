//
//  ClockComponentView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/9.
//

import SwiftUI

protocol ColckMarkStyle {
    associatedtype Body : View
    associatedtype Mark: View
    @ViewBuilder func makeBody(configuration: Self.Configuration<Mark>) -> Self.Body
    typealias Configuration = ClockMarkViewStyleConfiguration
}

struct ClockMarkViewStyleConfiguration<Mark: View> {
    let marks: Int
    let origin: Bool
    let content: (Int) -> Mark
}

struct  DefalutColckMarkStyle<Mark: View>: ColckMarkStyle {
    func makeBody(configuration: Configuration<Mark>) -> some View {
        return CircleColckMarkStyle().makeBody(configuration: configuration)
    }
}

struct CircleColckMarkStyle<Mark: View>: ColckMarkStyle {
    func makeBody(configuration: Configuration<Mark>) -> some View {
        return GeometryReader { geometry in
            let marks: Int = configuration.marks
            let minLength = min(geometry.size.width, geometry.size.height)
            let maxLength = max(geometry.size.width, geometry.size.height)
            let yOffset: CGFloat = (maxLength - minLength) / 2.0
            ForEach(0..<marks) { n in
                VStack {
                    if configuration.origin {
                        configuration.content(n)
                            .rotationEffect(-Angle(degrees: Double(n) * 360 / Double(marks)))
                    }else {
                        configuration.content(n)
                    }
                    Spacer()
                }
                .rotationEffect(Angle(degrees: Double(n) * 360 / Double(marks)))
            }
            .frame(width: minLength, height: minLength, alignment: .center)
            .offset(y: yOffset)
        }
    }
}

struct ClockMarkView<Mark: View>: View {
    private let configuration: ClockMarkViewStyleConfiguration<Mark>
    
    init(_ marks: Int = 12,
         origin: Bool = false,
         @ViewBuilder content: @escaping (Int) -> Mark) {
        self.configuration = .init(marks: marks, origin: origin, content: content)
    }
    
    var body: some View {
        DefalutColckMarkStyle().makeBody(configuration: configuration)
    }
    
    func clockMarkStyle<S: ColckMarkStyle>(_ style: S) -> some View where S.Mark == Mark {
        style.makeBody(configuration: configuration)
    }
}

fileprivate extension Date {
    var hourPercent: Double {
        var hour: Double = Double(Calendar.current.component(.hour, from: self))
        hour += self.minutePercent
        return hour / 12.0
    }
    var minutePercent: Double {
        var min = Double(Calendar.current.component(.minute, from: self))
        min += self.secondPercent
        return Double(min) / 60.0
    }
    var secondPercent: Double {
        let sec = Calendar.current.component(.second, from: self)
        return Double(sec) / 60.0
    }
}

struct ClockNeedleView<NeedleView: View>: View {
    enum ClockNeedle {
        case hour
        case minute
        case second
        func percent(date: Date) -> Double {
            switch self {
            case .hour: return date.hourPercent
            case .minute: return date.minutePercent
            case .second: return date.secondPercent
            }
        }
    }
    
    private let date: Date
    private let type: ClockNeedle
    private let content: () -> NeedleView
    
    init (_ date: Date, for type: ClockNeedle, @ViewBuilder content: @escaping () -> NeedleView) {
        self.date = date
        self.type = type
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let n: Double = type.percent(date: date)
            let minLength = min(geometry.size.width, geometry.size.height)
            let maxLength = max(geometry.size.width, geometry.size.height)
            let yOffset: CGFloat = (maxLength - minLength) / 2.0
            VStack {
                Spacer()
                content()
                Spacer()
                    .frame(height: minLength / 2.0)
            }
            .rotationEffect(Angle(degrees: n * 360))
            .frame(width: minLength, height: minLength, alignment: .center)
            .offset(y: yOffset)
        }
    }
}

#if DEBUG
struct ClockWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ClockMarkView(24) { index in
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 2, height: 10, alignment: .center)
            }
            ClockMarkView(12) { index in
                VStack(spacing: 0) {
                    Circle()
                            .fill(Color.green)
                        .frame(width: 8, height: 8, alignment: .center)
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 3, height: 10, alignment: .center)
                }
            }
            ClockMarkView(12, origin: true) { index in
                Text("\(index == 0 ? 12 : index)")
            }.padding()
            ClockNeedleView(Date(), for: .hour) {
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 5, height: 40, alignment: .center)
            }
            ClockNeedleView(Date(), for: .minute) {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 3, height: 50, alignment: .center)
            }
            ClockNeedleView(Date(), for: .second) {
                Rectangle()
                    .fill(Color.pink)
                    .frame(width: 3, height: 60, alignment: .center)
            }
            Circle()
                .frame(width: 5, height: 5, alignment: .center)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
#endif