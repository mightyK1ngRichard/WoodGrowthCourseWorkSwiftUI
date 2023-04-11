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
    // Тоже стоило бы это делать в другом месте. Но я был молод.
    @ObservedObject var pressed             = PressedButton()
    @ObservedObject var pressedCardInfo     = PressedButtonDetailView()
    @ObservedObject var pressedTreeInfoCard = PressedButtonTree()
    // Состояние для работников, нажатие глазика. Сорри что тут.
    @State private var pressedWateringLog   = false
    @Binding var email                      : String
    @Binding var password                   : String
    
    var body: some View {
        HStack {
            SideBar()
            switch (pressed.pressed) {
            case "Home":
                Home(email: $email, password: $password)
                    
            // ДА-ДА, мне очень стыдно за мою реализацию, но переделывать уже лень.
            case "Работники":
                // Если нажата кнопка обзор работника. PS. Сорри за реализацию, это первая моя карточка на SwiftUI...
                if pressedCardInfo.pressed {
                    HStack {
                        Employees(pressedWateringLog: $pressedWateringLog)
                        VStack {
                            DetailCard(pressedWateringLog: $pressedWateringLog, currentPersonInfo: pressedCardInfo.cardInfo!)
                            Spacer()
                        }
                        .padding(.top, 55)
                        .background(getGradient())
                    }
                    
                } else {
                    Employees(pressedWateringLog: $pressedWateringLog)
                }

            case "Деревья":
                Trees()
                
            case "Виды":
                TypeTrees()
                
            case "Участки":
                Plots()
                
            case "Удобрения":
                FertilizerView()
                
            case "Посавщики &\nПоставки":
                S_DViews()
                
            default:
                HStack {
                    Text("Лол, а как ты тут оказался")
                    Spacer()
                }
            }
        }
        .preferredColorScheme(.none)
        .background(Color(red: 35/255, green: 36/255, blue: 76/255))
        .environmentObject(pressed)
        .environmentObject(pressedCardInfo)
        .environmentObject(pressedTreeInfoCard)
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView(email: .constant("dimapermyakov55@gmail.com"), password: .constant("boss"))
    }
}
