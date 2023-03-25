//
//  SideBar.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

struct SideBar: View {
    @Namespace var animation
    @State private var isHovering    = false
    @EnvironmentObject var openMenu  : OpenMenu
    @State var isHoverExit           = false
    
    var body: some View {
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
                    

                    TabButton(image: "house.fill", title: "Home", animation: animation)
                    TabButton(image: "tree.circle", title: "Деревья", animation: animation)
                    TabButton(image: "person.fill", title: "Работники", animation: animation)
                    TabButton(image: "arrow.up.and.down.and.arrow.left.and.right", title: "Участки", animation: animation)
                    TabButton(image: "fork.knife.circle.fill", title: "Удобрения", animation: animation)
                    TabButton(image: "cart.fill", title: "Поставки", animation: animation)
                }
                
                Spacer(minLength: 0)
                                    
                Button {
                    // TODO: придумать

                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                        Text("Выход")
                            .font(.title3)
                            .brightness(isHoverExit ? -0.3 : 0)
                            .onHover { hovering in
                                self.isHoverExit = hovering
                            }
                    }
                    .onTapGesture {
                        openMenu.openMenu = false
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20)
                
            }
            Divider()
                .offset(x: -2)
        }
        .frame(width: 218)
        .background(getGradient())
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
