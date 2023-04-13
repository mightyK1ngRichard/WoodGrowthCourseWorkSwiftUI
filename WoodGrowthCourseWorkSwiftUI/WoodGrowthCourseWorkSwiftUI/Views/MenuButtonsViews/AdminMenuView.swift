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
    @ObservedObject var pressed = PressedButton()
    
    var body: some View {
        HStack {
            SideBar()
            
            switch (self.pressed.pressed) {
                
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
        .background(Color(red: 35/255, green: 36/255, blue: 76/255))
    }
}

struct AdminMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AdminMenuView()
    }
}
