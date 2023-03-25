//
//  TurnOffServer.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct TurnOffServer: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Image("turnoffserver")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 350)
                Text("😭 Сервер отключен. 😭")
                    .font(.system(size: 50))
                    .foregroundColor(Color(red: 1, green: 0, blue: 0))
                Spacer()
            }
            Spacer()
        }
    }
}

struct TurnOffServer_Previews: PreviewProvider {
    static var previews: some View {
        TurnOffServer()
    }
}
