//
//  AdminMenuView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

class PressedButton: ObservableObject {
    @Published var pressed = "Home"
}

struct AdminMenuView: View {
    let window = NSScreen.main?.visibleFrame
    @ObservedObject var pressed = PressedButton()
    
    var body: some View {
        Group {
            switch (pressed.pressed) {
            case "Home":
                HStack {
                    SideBar()
                    Text("Home")
                        .frame(minWidth: window!.width / 1.5, minHeight: window!.height - 50,maxHeight: window!.height - 50)
                }
                    
            case "Работники":
                Employees()
                    .frame(minWidth: window!.width / 1.5, minHeight: window!.height - 50,maxHeight: window!.height - 50)

            case "Деревья":
                HStack {
                    SideBar()
                    Text("Деревья")
                        .frame(minWidth: window!.width / 1.5, minHeight: window!.height - 50,maxHeight: window!.height - 50)
                }
                
            case "Участки":
                HStack {
                    SideBar()
                    Text("Участки")
                        .frame(minWidth: window!.width / 1.5, minHeight: window!.height - 50,maxHeight: window!.height - 50)
                }

            case "Поставки":
                HStack {
                    SideBar()
                    Text("Поставки")
                        .frame(minWidth: window!.width / 1.5, minHeight: window!.height - 50,maxHeight: window!.height - 50)
                }
                
            default:
                HStack {
                    SideBar()
                    EmptyView()
                    
                }
            }
        }
        .background(Color.white.opacity(0.6))
        .background(BlurWindow())
        .ignoresSafeArea(.all, edges: .all)
        .environmentObject(pressed)
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView()
    }
}
