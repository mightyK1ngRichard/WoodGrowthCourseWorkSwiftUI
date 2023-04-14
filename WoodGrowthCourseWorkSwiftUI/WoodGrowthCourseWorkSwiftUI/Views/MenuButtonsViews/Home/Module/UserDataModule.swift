//
//  UserDataModule.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 11.04.2023.
//

import Foundation

class UserData: ObservableObject {
    @Published var userData = UserResult(id: 0, login: "test", password: "test", photo: URL(string: "https://img3.goodfon.ru/wallpaper/nbig/7/fa/oboi-anime-devushki-miku-3104.jpg")!, firstname: "Дмитрий", lastname: "Пермяков", post: "Тестировщик")
    @Published var status = false
}

