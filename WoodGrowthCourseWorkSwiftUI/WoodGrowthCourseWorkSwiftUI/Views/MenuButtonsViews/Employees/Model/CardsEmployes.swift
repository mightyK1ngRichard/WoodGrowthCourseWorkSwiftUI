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
    @Published var statusParse                    = true
    
    init() {
        APIManager.shared.getEmployers {[weak self] data, error in
            guard let self = self else {
                print("== ERROR self")
                // ахаха. что?? Крч этот блок по фану.
                self?.statusParse = false
                return
            }
            guard let data = data else {
                print("== ERROR: ", error!)
                self.statusParse = false
                return
            }
            self.statusParse = true
            for el in data.rows {
                let newEmployeer = EmpoyeeResult(id: el.employer_id, fullName: el.full_name, phone: el.phone_number, post: el.post, ava: el.photo, namePlot: el.name_plot, nameType: el.name_type)
                self.employeesInfo.append(newEmployeer)

            }
        }
    }
}
