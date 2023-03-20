//
//  CardsEmployes.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import Foundation

import SwiftUI

class employeesCardsViewModel: ObservableObject {
    // Получаем данные из БД по работникам.
    
    @Published var employeesInfo: [EmpoyeeResult] = []
    
    init() {
        APIManager.shared.getEmployers { data, error in
            guard let data = data else {
                print("=== ERROR employeesCardsViewModel. Данных нету")
                return
            }
            for el in data.rows {
                let newEmployeer = EmpoyeeResult(id: el.employer_id, fullName: el.full_name, phone: el.phone_number, post: el.post, ava: el.photo)
                self.employeesInfo.append(newEmployeer)

            }
        }
    }
        
}
