//
//  Home.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

struct Home: View {
    let window = NSScreen.main?.visibleFrame
    @State var selected = "Home"
    @Namespace var animation
    
    var body: some View {
        HStack {
            HStack(spacing: 0) {
                VStack(spacing: 22) {
                    
                    Group {
                        HStack {
                            Image("logo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 45, height: 45)
                                .clipShape(Circle())
                            Text("Wood Business")
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                            Spacer(minLength: 0)
                        }
                        .padding(.top, 35)
                        .padding(.leading, 10)
                        // Tab Button
                        TabButton(image: "house.fill", title: "Home", animation: animation, selected: $selected)
                        
                        TabButton(image: "tree.circle", title: "Деревья", animation: animation, selected: $selected)
                        
                        TabButton(image: "person.fill", title: "Работники", animation: animation, selected: $selected)
                        
                        TabButton(image: "person.fill", title: "Деревья", animation: animation, selected: $selected)
                        
                        TabButton(image: "person.fill", title: "Участки", animation: animation, selected: $selected)
                    }
                    
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 5) {
                        Image("money")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        Button {
                            //
                        } label: {
                            Text("Прочее")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.gray)
                        }
                        .buttonStyle(PlainButtonStyle())

                    }
                    
                    Spacer(minLength: 0)
                }
                Divider()
                    .offset(x: -2)
            }
            .frame(width: 220)
            Spacer()
        }
//        .frame(width: window!.width / 1.5, height: window!.height - 40)
        .background(Color.white.opacity(0.6))
        .background(BlurWindow())
        .ignoresSafeArea(.all, edges: .all)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
