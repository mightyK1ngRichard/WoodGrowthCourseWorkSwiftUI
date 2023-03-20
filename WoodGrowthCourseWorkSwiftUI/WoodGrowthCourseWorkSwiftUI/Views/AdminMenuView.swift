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
        HStack {
            switch (pressed.pressed) {
            case "Home":
                Home()
                    
            case "Работники":
                Employees()

            case "Деревья":
                HStack {
                    SideBar()
                    Text("Деревья")
                }
                
            case "Участки":
                HStack {
                    SideBar()
                    Text("Участки")
                }

            case "Поставки":
                HStack {
                    SideBar()
                    Text("Поставки")
                }
                
            default:
                HStack {
                    SideBar()
                    EmptyView()
                    
                }
            }
        }
        .preferredColorScheme(.none)
        .background(Color.white.opacity(0.6))
        .environmentObject(pressed)
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView()
    }
}
