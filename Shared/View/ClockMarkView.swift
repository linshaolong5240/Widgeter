//
//  ClockMarkView.swift
//  Widgeter
//
//  Created by 林少龙 on 2021/6/9.
//

import SwiftUI

public protocol ColckMarkStyle {
    associatedtype Body : View
    @ViewBuilder func makeBody(configuration: Self.Configuration) -> Self.Body
    typealias Configuration = ClockMarkViewStyleConfiguration
}

public struct  DefalutColckMarkStyle: ColckMarkStyle {
    public func makeBody(configuration: Configuration) -> some View {
        return CircleColckMarkStyle().makeBody(configuration: configuration)
    }
}

public struct  CircleColckMarkStyle: ColckMarkStyle {
    public func makeBody(configuration: Configuration) -> some View {
        return GeometryReader { geometry in
            let number: Int = configuration.countOfMarks
            let minLength = min(geometry.size.width, geometry.size.height)
            let maxLength = max(geometry.size.width, geometry.size.height)
            let yOffset: CGFloat = (maxLength - minLength) / 2.0
            ForEach(0..<number) { n in
                Path { path in
                    path.move(to: CGPoint(x: minLength / 2.0, y: 0))
                    path.addLine(to: CGPoint(x: minLength / 2.0, y: configuration.lineLength))
                }
                .stroke(configuration.color, lineWidth: configuration.lineWidth)
                .border(Color.red)
                .rotationEffect(Angle(degrees: Double(n) * 360 / Double(number)))
            }
            .frame(width: minLength, height: minLength, alignment: .center)
            .offset(y: yOffset)
        }
    }
}

public struct ClockMarkViewStyleConfiguration {
    public let color: Color
    public let lineWidth: CGFloat
    public let lineLength: CGFloat
    public let countOfMarks: Int
    public let nuberMark: Bool = false
}

struct ClockMarkView: View {
    private let configuration: ClockMarkViewStyleConfiguration
    
    init(_ color: Color = .black, lineWidth: CGFloat = 4, lineLength: CGFloat = 10, countOfMarks: Int = 24) {
        self.configuration = .init(color: color, lineWidth: lineWidth, lineLength: lineLength, countOfMarks: countOfMarks)
    }
    
    var body: some View {
        DefalutColckMarkStyle().makeBody(configuration: configuration)
    }
    
    func clockMarkStyle<S>(_ style: S) -> some View where S: ColckMarkStyle {
        style.makeBody(configuration: configuration)
    }
}

#if DEBUG
struct ClockWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ClockMarkView(.gray)
            ClockMarkView(lineLength: 20, countOfMarks: 12)
        }
        .frame(width: 200, height: 200, alignment: .center)
    }
}
#endif
