//
//  UserDataModule.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 11.04.2023.
//

import Foundation

class UserData: ObservableObject {
    @Published var userData : UserResult?
    @Published var status   = false
    
    init(login: String, password: String) {
        APIManager.shared.getUserInfo(user: login, password: password, completion: { [weak self] data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                self?.status = false
                return
            }
            for el in data.rows {
                let newUser = UserResult(id: el.userid, login: el.login, password: el.password, photo: el.photo, firstname: el.firstname, lastname: el.lastname, post: el.post)
                
                self?.userData = newUser
            }
            self?.status = true
        })
    }
}
