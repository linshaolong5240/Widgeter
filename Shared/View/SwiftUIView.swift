//
//  SwiftUIView.swift
//  Widgeter
//
//  Created by qfdev on 2021/6/28.
//

import SwiftUI

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}

import SwiftUI

struct SwiftUIView: View {
  
    let leftG1 = 1...10
  
    @State var index:CGFloat = 0
  
    let colors = Gradient(colors: [Color.yellow,Color.red,Color.orange ])
  
  
  
    var body: some View {
  
        VStack{
            Text("SwiftUI 🌰").font(.title).bold().padding()
  
            //仪表盘容器
            ZStack{
                //同心圆
                Group{
                    Circle().stroke(Color.gray).frame(width:220,height:220)
                    Circle().fill(Color.white).frame(width:180,height:180)
                    Circle().fill(Color.blue).frame(width:80,height:80)
                    Circle().fill(Color.white).frame(width:60,height: 60)
                    Circle().fill(Color.blue).frame(width:40,height: 40)
                }
                Group{
                    //左侧仪表点
                    ForEach(leftG1,id:\.self){i  in
                        Text("·") .frame(width:10,height:10)
                            .offset( x: 0,  y: -70) .rotationEffect(.init(degrees:  Double(i * 9 ) * -1 ))
                            .foregroundColor( (Double(i * 9 ) * -1) ==  Double(index * 9) ? Color.blue :Color.gray )
                    }
                }
                Group{
                    //右侧仪表点
                    ForEach(leftG1,id:\.self){i  in
                        Text("·").frame(width:10,height:10)
                            .offset( x: 0, y: -70) .rotationEffect(.init(degrees:  Double(i * 9) ))
                            .foregroundColor( (Double(i * 9 ) ) ==  Double(index * 9) ? Color.blue :Color.gray )
                    }
                }
  
                //仪表数据
                VStack{
                    Text("\(Int(index))")
                    Text("value")
                }.offset(x: 0, y: 80).foregroundColor(Color.gray).font(.system(size: 13))
  
                GeometryReader{
                    proxy in
                    //进度条背景
                    Path{ path in
                        path.move(to: CGPoint(x:proxy.size.width / 2 - 90 , y:proxy.size.height / 2))
                        //绘制上弧形
                        path.addArc(center: CGPoint(x:proxy.size.width / 2   ,y:proxy.size.height / 2 ), radius: CGFloat(90), startAngle: Angle.init(degrees: -180), endAngle: Angle.init(
                                        degrees: Double(0) ), clockwise: false)
          
                    }
                    .stroke(Color.gray,style: StrokeStyle(lineWidth: 15, lineCap: .round))
      
                    //进度条
                    Path{ path in
                        path.move(to: CGPoint(x:proxy.size.width / 2 - 90 , y:proxy.size.height / 2))
                        //绘制上弧形
                        path.addArc(center: CGPoint(x:proxy.size.width / 2  ,y:proxy.size.height / 2 ), radius: CGFloat(90), startAngle: Angle.init(degrees: -180), endAngle: Angle.init(
                                        degrees: Double((-1 * (180 - index * 9))) ), clockwise: false)
          
                    }
                    .stroke(LinearGradient(gradient: colors,startPoint: .topLeading,endPoint: .bottomTrailing),style: StrokeStyle(lineWidth: 15, lineCap: .round))
      
                }.frame(width:220,height:220)
                //指针
                Image("arrow").resizable().frame(width:60,height:60).offset(x: 0, y: -16)
                    .rotationEffect(.init(degrees:  Double(index * 9) - 90 )).animation(.linear)
  
            }.padding()
  
            Slider(value: $index, in: 0...19, step:1){_ in
                withAnimation{
                    index += 1
                }
            }.padding()
  
        }
  
  
  
  
    }
}
