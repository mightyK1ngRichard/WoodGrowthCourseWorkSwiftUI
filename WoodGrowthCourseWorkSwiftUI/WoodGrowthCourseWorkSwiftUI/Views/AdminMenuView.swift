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


class PressedButtonDetailView: ObservableObject {
    // Нажали обзор работника?
    @Published var pressed = false
    
    // Данные по работнику из нажатой карты.
    @Published var cardInfo: EmpoyeeResult? = nil
}


struct AdminMenuView: View {
    let window = NSScreen.main?.visibleFrame
    @ObservedObject var pressed = PressedButton()

    @ObservedObject var pressedCardInfo = PressedButtonDetailView()
    
    var body: some View {
        HStack {
            switch (pressed.pressed) {
            case "Home":
                Home()
                    
            case "Работники":
                // Если нажата кнопка обзор работника.
                if pressedCardInfo.pressed {
                    HStack {
                        Employees()
                        DetailCard(currentPersonInfo: pressedCardInfo.cardInfo)
                    }
                    
                } else {
                    Employees()
                }

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
        .environmentObject(pressedCardInfo)
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView()
    }
}
