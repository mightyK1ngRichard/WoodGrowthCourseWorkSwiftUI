//
//  BlurWindow.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

struct BlurWindow: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        
    }
}

struct BlurWindow_Previews: PreviewProvider {
    static var previews: some View {
        BlurWindow()
    }
}

func getGradient() -> LinearGradient {
    let colors = Gradient(colors: [.purple, .blue])
    return LinearGradient(gradient: colors, startPoint: .top, endPoint: .bottom)
}

func getTabBackground() -> Color {
    return Color(red: 35/255, green: 36/255, blue: 76/255)
}
