//
//  CornerGaugeView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/7/1.
//

import SwiftUI

enum Corner {
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
}

extension Corner {
    var startAngle: Angle {
        switch self {
        case .topLeading: return .degrees(33 * 6)
        case .topTrailing: return .degrees(48 * 6)
        case .bottomLeading: return .degrees(27 * 6)
        case .bottomTrailing: return .degrees(12 * 6)
        }
    }
    
    var endAngle: Angle {
        switch self {
        case .topLeading: return .degrees(42 * 6)
        case .topTrailing: return .degrees(57 * 6)
        case .bottomLeading: return .degrees(18 * 6)
        case .bottomTrailing: return .degrees(3 * 6)
        }
    }
    
    var leadingAngle: Angle {
        switch self {
        case .topLeading: return .degrees(-78)
        case .topTrailing: return .degrees(12)
        case .bottomLeading: return .degrees(78)
        case .bottomTrailing: return .degrees(-12)
        }
    }
    
    var trailingAngle: Angle {
        switch self {
        case .topLeading: return .degrees(-6)
        case .topTrailing: return .degrees(84)
        case .bottomLeading: return .degrees(6)
        case .bottomTrailing: return .degrees(-84)
        }
    }
    
    var isTop: Bool {
        switch self {
        case .topLeading, .topTrailing: return true
        case .bottomLeading, .bottomTrailing: return false
        }
    }
    
    var isBottom: Bool {
        !isTop
    }
    
    var cornerAlignment: Alignment {
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
    
    var cornerTextAngle: Angle {
        switch  self {
        case .topLeading:       return .degrees(-45)
        case .topTrailing:         return .degrees(45)
        case .bottomLeading:    return .degrees(45)
        case .bottomTrailing:      return .degrees(-45)
        }
    }

}

struct ClockCornerGaugeView: View {
    @Environment(\.colorScheme) private var colorScheme

    let percent: Double
    let colors: [Color]
    let position: Corner
    
    init(_ percent: Double,
         colors: [Color] = [.accentColor],
         position: Corner) {
        self.colors = colors
        self.percent = percent
        self.position = position
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2.0, y: geometry.size.height / 2.0)
            let strokeLineWidth = minLength * 0.05
            let radius = (minLength - strokeLineWidth) / 2.0
            if colors.count == 1 {
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: position.startAngle, endAngle: position.endAngle, clockwise: position.isBottom)
                }
                .stroke(colors[0].opacity(0.35), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                Path { path in
                    path.addArc(center: center, radius: radius, startAngle: position.startAngle, endAngle: position.startAngle + (position.endAngle - position.startAngle) * percent, clockwise: position.isBottom)
                }
                .stroke(colors[0], style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
            }else {
                ZStack {
                    Path { path in
                        path.addArc(center: center, radius: radius, startAngle: position.startAngle, endAngle: position.endAngle, clockwise: position.isBottom)
                    }
                    .stroke(AngularGradient(
                                gradient: Gradient(colors: colors),
                                center: .center,
                                startAngle: position.startAngle,
                                endAngle: position.endAngle), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round))
                    VStack {
                        Spacer()
                        Circle().stroke(colorScheme == .light ? Color.white : Color.black, lineWidth: strokeLineWidth / 5.0)
                            .frame(width: strokeLineWidth, height: strokeLineWidth, alignment: .center)
                    }
                    .frame(width: minLength, height: minLength, alignment: .center)
                    .rotationEffect((position.startAngle - .degrees(90)) + (position.endAngle - position.startAngle) * percent )
                }
            }
        }
    }
}

struct ClockCornerGaugeRangeView: View {
    let percent: Double
    let colors: [Color]
    let position: Corner
    let leadingTextProvider: Text
    let trailingTextProvider: Text
    
    init(_ percent: Double,
         colors: [Color],
         position: Corner,
         leadingTextProvider: Text,
         trailingTextProvider: Text) {
        self.colors = colors
        self.percent = percent
        self.position = position
        self.leadingTextProvider = leadingTextProvider
        self.trailingTextProvider = trailingTextProvider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                ClockCornerGaugeView(percent, colors: colors, position: position)
                ZStack {
                    VStack {
                        if position.isBottom { Spacer() }
                        leadingTextProvider.font(.system(size: minLength / 20.0)).lineLimit(1)
                        if position.isTop { Spacer() }
                    }
                    .rotationEffect(position.leadingAngle)
                    VStack {
                        if position.isBottom { Spacer() }
                        trailingTextProvider.font(.system(size: minLength / 20.0)).lineLimit(1)
                        if position.isTop { Spacer() }
                    }
                    .rotationEffect(position.trailingAngle)
                }
                .frame(width: minLength, height: minLength, alignment: .center)
            }
        }
    }
}

struct CornerGaugeImageView<Content: View>: View {
    let percent: Double
    let colors: [Color]
    let position: Corner
    let leadingTextProvider: Text
    let trailingTextProvider: Text
    let imageProvider: () -> Content

    init(_ percent: Double,
         colors: [Color],
         position: Corner,
         leadingTextProvider: Text,
         trailingTextProvider: Text,
         @ViewBuilder imageProvider: @escaping () -> Content) {
        self.colors = colors
        self.percent = percent
        self.position = position
        self.leadingTextProvider = leadingTextProvider
        self.trailingTextProvider = trailingTextProvider
        self.imageProvider = imageProvider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                ClockCornerGaugeRangeView(percent, colors: colors, position: position, leadingTextProvider: leadingTextProvider, trailingTextProvider: trailingTextProvider)
                ZStack(alignment: position.cornerAlignment) {
                    Color.clear
                    imageProvider()
                        .foregroundColor(colors.intermediate(percent: CGFloat(percent)))
                        .padding(minLength / 50)
                        .frame(width: minLength / 8, height: minLength / 8)
                }
                .frame(width: minLength * 0.95, height: minLength * 0.95)
            }
        }
    }
}

struct CornerGaugeSimpleTextView: View {
    let percent: Double
    let colors: [Color]
    let position: Corner
    let textProvider: Text

    init(_ percent: Double,
         colors: [Color],
         position: Corner,
         textProvider: Text) {
        self.percent = percent
        self.colors = colors
        self.position = position
        self.textProvider = textProvider
    }
    
    var body: some View {
        GeometryReader { geometry in
            let minLength = min(geometry.size.width, geometry.size.height)
            ZStack {
                ClockCornerGaugeView(percent, colors: colors, position: position)
                ZStack(alignment: position.cornerAlignment) {
                    Color.clear
                    textProvider
                        .font(.system(size: minLength / 16))
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .frame(width: minLength / 7, height: minLength / 7)
                        .rotationEffect(position.cornerTextAngle)
                }
                .frame(width: minLength * 0.95, height: minLength * 0.95)
            }
        }
    }
}


#if DEBUG
struct CornerGaugeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            CornerGaugeImageView(0.5,
                                 colors: [.pink],
                                 position: .topTrailing,
                                 leadingTextProvider: Text("0"),
                                 trailingTextProvider: Text("100")) {
                Image(systemName: "heart.fill").resizable().foregroundColor(.pink) }
            CornerGaugeSimpleTextView(0.5,
                                      colors: [.green, .orange, .pink],
                                      position: .bottomTrailing,
                                      textProvider: Text("50%"))
            
        }
    }
}
#endif
