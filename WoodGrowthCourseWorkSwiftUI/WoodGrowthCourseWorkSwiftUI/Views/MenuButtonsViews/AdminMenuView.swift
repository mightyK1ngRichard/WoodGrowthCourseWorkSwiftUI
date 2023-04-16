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
    @ObservedObject var pressed     = PressedButton()
    @EnvironmentObject var userData : UserData
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        HStack {
            SideBar()
            
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
        .background(getTabBackground())
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        let default1 = PressedButton()
        let default2 = UserData()
        AdminMenuView()
            .environmentObject(default1)
            .environmentObject(default2)
    }
}
