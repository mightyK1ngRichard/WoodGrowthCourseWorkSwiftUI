//
//  SideBar.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
struct PopoverView: View {
    var body: some View {
        VStack {
            Text("This is a Popover!")
            Button("Close") {
                NSApp.stopModal()
            }
            .padding()
        }
        .frame(width: 200, height: 100)
    }
}

struct SideBar: View {
    var colors                        = getGradient()
    var imageColor                    = Color.black
    var colorOfLetters                = Color.black
    @EnvironmentObject var userData   : UserData
    @EnvironmentObject var pressed    : PressedButton
    @Namespace var animation
    @State private var isHovering     = false
    @State private var isHoverExit    = false
    
    
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
                            .foregroundColor(colorOfLetters)
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 35)
                    .padding(.leading, 10)
                    
                    if ["Home", "Поставщики &\nПоставки"].contains(pressed.pressed) {
                        TabButton(image: "house", title: "Home", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        TabButton(image: "arrow.up.and.down.and.arrow.left.and.right", title: "Участки", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        TabButton(image: "square.stack.3d.up", title: "Виды", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        TabButton(image: "person.2", title: "Работники", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        TabButton(image: "leaf", title: "Удобрения", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        TabButton(image: "tree", title: "Деревья", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        TabButton(image: "cart", title: "Поставщики &\nПоставки", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        
                    } else {
                        TabButton(image: "house.fill", title: "Home", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: imageColor)
                        TabButton(image: "arrow.up.and.down.and.arrow.left.and.right", title: "Участки", animation: animation, colorOfLetters: colorOfLetters)
                        TabButton(image: "square.stack.3d.up.fill", title: "Виды", animation: animation, colorOfLetters: colorOfLetters)
                        TabButton(image: "person.2.fill", title: "Работники", animation: animation, colorOfLetters: colorOfLetters)
                        TabButton(image: "leaf.fill", title: "Удобрения", animation: animation, colorOfLetters: colorOfLetters)
                        TabButton(image: "tree.fill", title: "Деревья", animation: animation, colorOfLetters: colorOfLetters)
                        TabButton(image: "cart.fill", title: "Поставщики &\nПоставки", animation: animation, colorOfLetters: colorOfLetters)
                    }
                    
                }
                
                Spacer(minLength: 0)
                                    
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
                    userData.status = false
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20)
                
            }
        }
        .frame(width: 210)
        .background(colors)
    }
}

struct SideBarUser: View {
    var colors                        = getGradient()
    var imageColor                    = Color.black
    var colorOfLetters                = Color.black
    @EnvironmentObject var userData   : UserData
    @EnvironmentObject var pressed    : PressedButton
    @Namespace var animation
    @State private var isHovering     = false
    @State private var isHoverExit    = false
    
    
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
                            .foregroundColor(colorOfLetters)
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 35)
                    .padding(.leading, 10)
                    
                    if pressed.pressed == "Home" {
                        TabButton(image: "house", title: "Home", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        TabButton(image: "arrow.up.and.down.and.arrow.left.and.right", title: "Участки", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        TabButton(image: "square.stack.3d.up", title: "Виды", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: .white)
                        
                    } else {
                        TabButton(image: "house.fill", title: "Home", animation: animation, colorOfLetters: colorOfLetters, colorOfImage: imageColor)
                        TabButton(image: "arrow.up.and.down.and.arrow.left.and.right", title: "Участки", animation: animation, colorOfLetters: colorOfLetters)
                        TabButton(image: "square.stack.3d.up.fill", title: "Виды", animation: animation, colorOfLetters: colorOfLetters)
                    }
                    
                }
                
                Spacer(minLength: 0)
                                    
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
                    userData.status = false
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 20)
                
            }
        }
        .frame(width: 210)
        .background(colors)
    }
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        let default1 = UserData()
        let default2 = PressedButton()
        
        SideBar(colors: LinearGradient(colors: [Color(red: 35/255.0, green: 35/255.0, blue: 36/255.0)], startPoint: .top, endPoint: .bottom), colorOfLetters: .white)
            .environmentObject(default1)
            .environmentObject(default2)
    }
}
