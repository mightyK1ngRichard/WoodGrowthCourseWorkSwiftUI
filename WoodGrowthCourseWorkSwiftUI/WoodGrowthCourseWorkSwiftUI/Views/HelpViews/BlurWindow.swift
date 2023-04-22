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
    var textForUser   : String
    @Binding var text : String
    
    var body: some View {
        TextField(textForUser, text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.3))
            .cornerRadius(8)
    }
}

struct MyTextFieldBlack: View {
    var textForUser   : String
    @Binding var text : String
    
    var body: some View {
        TextField(textForUser, text: $text)
            .textFieldStyle(PlainTextFieldStyle())
            .padding(10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(8)
    }
}

//struct MyTextField: View {
//    var textForUser: String
//    @Binding var text: String
//
//    var body: some View {
//        HStack(spacing: 3){
//            TextField(textForUser, text: $text)
//                .editBackGround()
//        }
//
//    }
//}

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

extension Color {
    init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255)
    }
}
