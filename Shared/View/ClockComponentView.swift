//
//  ClockComponentView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/9.
//
import WidgetKit
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

enum ClockCorner {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
    var startAngle: Angle {
        switch self {
        case .topLeading, .topTrailing: return .degrees(33 * 6)
        case .bottomLeading, .bottomTrailing: return .degrees(3 * 6)
        }
    }
    var endAngle: Angle {
        switch self {
        case .topLeading, .topTrailing: return .degrees(42 * 6)
        case .bottomLeading, .bottomTrailing: return .degrees(12 * 6)
        }
    }
    func percentAngle(_ percent: Double) -> Angle {
        switch self {
        case .topLeading, .topTrailing: return .degrees(percent * 9 * 6)
        case .bottomLeading, .bottomTrailing: return .degrees((1 - percent) * 9 * 6)
        }
    }
    var isTop: Bool {
        switch self {
        case .topLeading, .topTrailing: return true
        case .bottomLeading, .bottomTrailing: return false
        }
    }
    var alignment: Alignment {
        switch self {
        case .topLeading:       return .topLeading
        case .topTrailing:         return .topTrailing
        case .bottomLeading:    return .bottomLeading
        case .bottomTrailing:      return .bottomTrailing
        }
    }
    var cornerPadding: Edge.Set {
        switch  self {
        case .topLeading:       return [.top, .leading]
        case .topTrailing:         return [.top, .trailing]
        case .bottomLeading:    return [.bottom, .leading]
        case .bottomTrailing:      return [.bottom, .trailing]
        }
    }
    
    var textAngle: Angle {
        switch  self {
        case .topLeading:       return .degrees(-45)
        case .topTrailing:         return .degrees(45)
        case .bottomLeading:    return .degrees(45)
        case .bottomTrailing:      return .degrees(-45)
        }
    }
}

struct ClockTemplateCornerGaugeImageView<Content: View>: View {
    let percent: Double
    let color: Color
    let position: ClockCorner
    let leadingText: Text?
    let trailingText: Text?
    let content: (_ value: Double) -> Content
    
    init(percent: Double,
         color: Color,
         position: ClockCorner,
         leadingText: Text? = nil,
         trailingText: Text? = nil,
         @ViewBuilder content: @escaping (_ value: Double) -> Content) {
        self.percent = percent
        self.color = color
        self.position = position
        self.leadingText = leadingText
        self.trailingText = trailingText
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            let radius = minLength * 0.46
            let strokeLineWidth = minLength * 0.03
            ZStack(alignment: position.alignment) {
                content(percent)
                    .frame(width: minLength / 12.0, height: minLength / 12.0, alignment: .center)
                    .frame(width: minLength / 5.0, height: minLength / 5.0, alignment: .center)
                ZStack {
                    ZStack {
                        Path { path in
                            path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: position.startAngle, endAngle: position.endAngle, clockwise: false)
                        }
                        .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                        Path { path in
                            path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0),
                                        radius: radius,
                                        startAngle: position.startAngle + (position.isTop ? .degrees(0) : position.percentAngle(percent)),
                                        endAngle: position.isTop ? position.startAngle + position.percentAngle(percent) : position.endAngle,
                                        clockwise: false)
                        }
                        .stroke(color, style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                    }
                    VStack {
                        if !position.isTop { Spacer() }
                        leadingText?.font(.system(size: 10)).foregroundColor(.white)
                        if position.isTop { Spacer() }
                    }
                    .rotationEffect(.degrees(position.isTop ? -78 : -6))
                    VStack {
                        if !position.isTop { Spacer() }
                        trailingText?.font(.system(size: 10)).foregroundColor(.white)
                        if position.isTop { Spacer() }
                    }
                    .rotationEffect(.degrees(position.isTop ? -6 : -84))
                }
                .rotationEffect(.degrees(position == .topTrailing ? 90 : 0))
                .rotationEffect(.degrees(position == .bottomLeading ? 90 : 0))
            }
        }
    }
}

struct ClockTemplateCornerGaugeTextView: View {
    let percent: Double
    let color: Color
    let position: ClockCorner
    let leadingText: Text?
    let trailingText: Text?
    let text: Text
    
    init(percent: Double,
         color: Color,
         position: ClockCorner,
         leadingText: Text? = nil,
         trailingText: Text? = nil,
         text: Text) {
        self.percent = percent
        self.color = color
        self.position = position
        self.leadingText = leadingText
        self.trailingText = trailingText
        self.text = text
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack(alignment: position.alignment) {
            let minLength = min(geometry.size.width, geometry.size.height)
            let radius = minLength * 0.46
            let strokeLineWidth = minLength * 0.03
                text
                    .font(.system(size: 26))
                    .minimumScaleFactor(0.4)
                    .foregroundColor(.white)
                    .rotationEffect(position.textAngle)
                    .frame(width: minLength / 5.0, height: minLength / 5.0, alignment: .center)
                    .frame(width: minLength / 4.0, height: minLength / 4.0, alignment: .center)
                ZStack {
                    ZStack {
                        Path { path in
                            path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0), radius: radius, startAngle: position.startAngle, endAngle: position.endAngle, clockwise: false)
                        }
                        .stroke(color.opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                        Path { path in
                            path.addArc(center: CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0),
                                        radius: radius,
                                        startAngle: position.startAngle + (position.isTop ? .degrees(0) : position.percentAngle(percent)),
                                        endAngle: position.isTop ? position.startAngle + position.percentAngle(percent) : position.endAngle,
                                        clockwise: false)
                        }
                        .stroke(color, style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                    }
                    VStack {
                        if !position.isTop { Spacer() }
                        leadingText?.font(.system(size: 10)).foregroundColor(.white)
                        if position.isTop { Spacer() }
                    }
                    .rotationEffect(.degrees(position.isTop ? -84 : -6))
                    VStack {
                        if !position.isTop { Spacer() }
                        trailingText?.font(.system(size: 10)).foregroundColor(.white)
                        if position.isTop { Spacer() }
                    }
                    .rotationEffect(.degrees(position.isTop ? -6 : -84))
                }
                .rotationEffect(.degrees(position == .topTrailing ? 90 : 0))
                .rotationEffect(.degrees(position == .bottomLeading ? 90 : 0))
            }
        }
    }
}

#if DEBUG
struct ClockComponentView_Previews: PreviewProvider {
    static var previews: some View {
        WatchFaceWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
