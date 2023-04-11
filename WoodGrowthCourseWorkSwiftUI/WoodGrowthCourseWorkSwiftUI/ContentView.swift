//
//  ContentView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI


class OpenMenu: ObservableObject {
    @Published var openMenu = false
}

struct ContentView: View {
    @ObservedObject var openMenu = OpenMenu()
    @State private var email     = ""
    @State private var password  = ""
    
    var body: some View {
        HStack {
            if openMenu.openMenu {
                AdminMenuView(email: $email, password: $password)
                
            } else {
                Authorization(email: $email, password: $password)
            }
        }
        .environmentObject(openMenu)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
