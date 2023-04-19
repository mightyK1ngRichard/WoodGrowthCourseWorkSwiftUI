//
//  TabButton.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

struct TabButton: View {
    @EnvironmentObject var selected : PressedButton
    var image                       : String
    var title                       : String
    var animation                   : Namespace.ID
    var colorOfLetters              = Color.black
    var colorOfImage                = Color.black
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selected.pressed = title
            }
        }, label: {
            HStack {
                Image(systemName: image)
                    .font(.title2)
                    .foregroundColor(selected.pressed == title ? colorOfImage : colorOfImage.opacity(0.5))
                    .frame(width: 15)
                    .padding(.leading, 7)
                
                Text(title)
                    .foregroundColor(colorOfLetters)
                    .fontWeight(selected.pressed == title ? .semibold : .none)
                    .animation(.none)
                    .padding(.horizontal)
                Spacer()
                
                ZStack {
                    Capsule()
                        .fill(Color.clear)
                        .frame(width: 3, height: 25)
                    
                    if selected.pressed == title {
                        Capsule()
                            .fill(colorOfImage)
                            .frame(width: 3, height: 25)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                            .offset(x: 1.5)
                    }
                }
            }
            .padding(.leading)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct TabButton_Previews: PreviewProvider {
    static var previews: some View {
        let defaultButton = PressedButton()
        @Namespace var animation
        TabButton(image: "house", title: "Дом", animation: animation)
            .environmentObject(defaultButton)
    }
}
