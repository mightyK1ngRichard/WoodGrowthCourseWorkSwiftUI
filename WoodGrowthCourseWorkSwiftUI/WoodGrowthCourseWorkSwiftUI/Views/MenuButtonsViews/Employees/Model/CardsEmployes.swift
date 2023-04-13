//
//  CardsEmployes.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import Foundation
import SwiftUI

class employeesCardsViewModel: ObservableObject {
    @Published var employeesInfo: [EmpoyeeResult] = []
    @Published var statusParse                    = true
    
    init() {
        refresh()
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.statusParse = false
        }
        
        APIManager.shared.getEmployers {[weak self] data, error in
            guard let data = data else {
                print("== ERROR FROM employeesCardsViewModel: ", error!)
                self?.statusParse = false
                return
            }
            var tempData : [EmpoyeeResult] = []
            for el in data.rows {
                let newEmployeer = EmpoyeeResult(id: el.employer_id, fullName: el.full_name, phone: el.phone_number, post: el.post, ava: el.photo, namePlot: el.name_plot ?? "Не назначено", nameType: el.name_type ?? "Не назначено")
                tempData.append(newEmployeer)
            }
            DispatchQueue.main.async {
                self?.employeesInfo = tempData
                self?.statusParse = true
            }
        }
    }
}

class PressedButtonDetailView: ObservableObject {
    @Published var pressed                  = false
    @Published var cardInfo: EmpoyeeResult? = nil
}
