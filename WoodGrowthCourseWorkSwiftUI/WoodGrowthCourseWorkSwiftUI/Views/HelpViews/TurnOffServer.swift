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
                VStack {
                    Text("Идёт подключение к серверу...")
                    ProgressView()
                }
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
