//
//  Rings.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 18.04.2023.
//

import SwiftUI

struct Rings: View {
    var percent  : CGFloat = 20
    var size     : CGFloat = 40
    var plotName = "W"
    
    var body: some View {
        let progress = (100 - percent) / 100
        
        return VStack {
            Text("**Участок:** \(plotName)")
                .font(.system(size: 14, design: .serif))
                .padding(.top, 5)
            
            getRing(percent, size, plotName, progress)
            
             Text("От всего V³")
                .font(.system(size: 14, design: .serif))
        }
        .frame(width: 90)
        
    }
    
    func getRing(_ percent: CGFloat, _ size: CGFloat, _ plotName: String, _ progress: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 2)
                .frame(width: size, height: size)
                .foregroundColor(.gray.opacity(0.5))
            
            Circle()
                .trim(from: progress, to: 1)
                .stroke(LinearGradient(colors: [.orange, .red], startPoint: .topTrailing, endPoint: .bottomLeading), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
                .rotationEffect(Angle(degrees: 90))
                .rotation3DEffect(Angle(degrees: 180), axis: (x: 1, y: 0, z: 0))
                .frame(width: size, height: size)
                .shadow(color: .red, radius: 1)
            
            Text("\(Int(percent))%")
                .font(.system(size: size * 0.3))
                .bold()
        }
    }
}

struct Rings_Previews: PreviewProvider {
    static var previews: some View {
        Rings()
    }
}
