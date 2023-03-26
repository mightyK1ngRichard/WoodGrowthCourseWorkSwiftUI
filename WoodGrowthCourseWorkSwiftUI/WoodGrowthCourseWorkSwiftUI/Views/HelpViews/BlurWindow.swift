//
//  BlurWindow.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

func getGradient() -> LinearGradient {
    let colors = Gradient(colors: [.purple, .blue])
    return LinearGradient(gradient: colors, startPoint: .top, endPoint: .bottom)
}

func getTabBackground() -> Color {
    return Color(red: 35/255, green: 36/255, blue: 76/255)
}
