//
//  UserDataModule.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 11.04.2023.
//

import Foundation

class UserData: ObservableObject {
    @Published var userData = UserResult(id: 0, login: "test", password: "test", photo: nil, firstname: "Дмитрий", lastname: "Пермяков", post: "Тестировщик")
    @Published var status = false
}
