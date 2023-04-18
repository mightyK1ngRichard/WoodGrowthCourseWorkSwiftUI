//
//  AdminMenuView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

class PressedButton: ObservableObject {
    @Published var pressed = "Home"
    
// TODO: Потом сделать через enum.
//    enum Menu: String {
//        case home                    = "Home"
//        case workers                 = "Работники"
//        case trees                   = "Деревья"
//        case types                   = "Виды"
//        case plots                   = "Участки"
//        case fertilizers             = "Удобрения"
//        case supliersAndDeliveries   = "Посавщики &\nПоставки"
//    }
}

struct AdminMenuView: View {
    @ObservedObject var pressed     = PressedButton()
    @EnvironmentObject var userData : UserData
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        HStack {
            if pressed.pressed == "Home"{
                SideBar(colors: LinearGradient(colors: [Color(red: 35/255.0, green: 35/255.0, blue: 36/255.0)], startPoint: .top, endPoint: .bottom), imageColor: Color.white, colorOfLetters: .white)
            } else {
                SideBar(colors: getGradient(), colorOfLetters: .black)
            }
            
            
            switch (pressed.pressed) {
                
            case "Home":
                Home()
                    
            case "Работники":
                Employees()

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
        .environmentObject(pressed)
        .preferredColorScheme(.none)
        .background(["Home"].contains(pressed.pressed) ? .black : getTabBackground())
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let default1 = PressedButton()
        let default2 = UserData()
        AdminMenuView()
            .environmentObject(default1)
            .environmentObject(default2)
            .onAppear() {
                default2.status = true
            }
    }
}
