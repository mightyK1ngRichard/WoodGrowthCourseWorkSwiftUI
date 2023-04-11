//
//  BlurWindow.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

func getGradient() -> LinearGradient {
//    let colors = Gradient(colors: [.purple, .blue])
    let colors = [Color(red: 1.0, green: 0.25, blue: 1.0), Color(red: 0.02, green: 0.2, blue: 1.0)]
    return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
}

func getTabBackground() -> Color {
    return Color(red: 35/255, green: 36/255, blue: 76/255)
}
