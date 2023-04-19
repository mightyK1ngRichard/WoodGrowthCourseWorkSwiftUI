//
//  BlurWindow.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

func getGradient() -> LinearGradient {
    let colors = [Color(red: 1.0, green: 0.25, blue: 1.0), Color(red: 0.02, green: 0.2, blue: 1.0)]
    return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
}

func getTabBackground() -> Color {
    return Color(red: 35/255, green: 36/255, blue: 76/255)
}

//func getTabBackground() -> LinearGradient {
//    let colors = [Color(red: 25/255, green: 25/255, blue: 94/255), Color(red: 81/255, green: 18/255, blue: 150/255)]
//    return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
//}

func myNewBackground() -> LinearGradient {
    let colors = [Color(red: 25/255, green: 25/255, blue: 94/255), Color(red: 81/255, green: 18/255, blue: 150/255)]
    return LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
}

struct MyTextField: View {
    var textForUser: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 3){
            TextField(textForUser, text: $text)
                .editBackGround()
        }
        
    }
}

extension TextField {
    func editBackGround() -> some View {
        return self
            .padding(2)
            .textFieldStyle(PlainTextFieldStyle())
            .foregroundColor(Color.white)
            .padding(2)
            .border(Color.white.opacity(0.3))
            .cornerRadius(2.4)
    }
}
