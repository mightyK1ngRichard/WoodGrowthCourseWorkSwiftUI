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
    @Published var pressed                  = false
    @Published var cardInfo: EmpoyeeResult? = nil
}

class PressedButtonTree: ObservableObject {
    @Published var pressed                  = false
    @Published var treeInfo: TreeResult?    = nil
}

struct AdminMenuView: View {
    @ObservedObject var pressed             = PressedButton()
    @ObservedObject var pressedCardInfo     = PressedButtonDetailView()
    @ObservedObject var pressedTreeInfoCard = PressedButtonTree()
    
    var body: some View {
        HStack {
            SideBar()
            switch (pressed.pressed) {
            case "Home":
                Home()
                    
            case "Работники":
                // Если нажата кнопка обзор работника.
                if pressedCardInfo.pressed {
                    HStack {
                        Employees()
                        Divider()
                            .offset(x: 7)
                        VStack {
                            DetailCard(currentPersonInfo: pressedCardInfo.cardInfo!)
                            Spacer()
                        }
                        .padding(.top, 55)
                        .background(getGradient())
                    }
                    
                } else {
                    Employees()
                }

            case "Деревья":
                HStack {
                    Trees()
                }
                
            case "Участки":
                Plats()

            case "Поставки":
                Deliveries()
                
            default:
                HStack {
                    Text("Лол, а как ты тут оказался")
                }
            }
        }
        .preferredColorScheme(.none)
        .background(Color.white.opacity(0.6))
        .environmentObject(pressed)
        .environmentObject(pressedCardInfo)
        .environmentObject(pressedTreeInfoCard)
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView()
    }
}
