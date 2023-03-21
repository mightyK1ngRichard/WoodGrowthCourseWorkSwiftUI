//
//  TabButton.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

struct TabButton: View {
    var image: String
    var title: String
    var animation: Namespace.ID
    @EnvironmentObject var selected: PressedButton
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selected.pressed = title
            }
        }, label: {
            HStack {
                Image(systemName: image)
                    .font(.title2)
                    .foregroundColor(selected.pressed == title ? Color.black : black)
                
                Text(title)
                    .fontWeight(selected.pressed == title ? .semibold : .none)
                    .animation(.none)
                    .padding(.horizontal)
                Spacer()
                
                // Capsule ...
                ZStack {
                    Capsule()
                        .fill(Color.clear)
                        .frame(width: 3, height: 25)

                    if selected.pressed == title {
                        Capsule()
                            .fill(Color.black)
                            .frame(width: 3, height: 25)
                            .matchedGeometryEffect(id: "Tab", in: animation)
                    }
                }
            }
            .padding(.leading)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

var black = Color.black.opacity(0.5)
