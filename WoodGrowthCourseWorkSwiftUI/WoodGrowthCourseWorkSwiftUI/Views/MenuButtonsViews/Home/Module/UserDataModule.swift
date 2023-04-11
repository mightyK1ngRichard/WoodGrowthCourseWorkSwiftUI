//
//  UserDataModule.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 11.04.2023.
//

import Foundation

class UserData: ObservableObject {
    @Published var userData = UserResult(id: 0, login: "test", password: "test", photo: nil, firstname: "test", lastname: "test", post: "test")
    @Published var status = false
}
