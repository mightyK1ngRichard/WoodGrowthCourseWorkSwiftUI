//
//  FertilizerData.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import Foundation

class FertilizerData: ObservableObject {
    @Published var fertilizerData : [FertilizerResult] = []
    @Published var status         = false
    
    init() {
        APIManager.shared.getFertilizer { [weak self] data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                self?.status = false
                return
            }
            for el in data.rows {
                let newFertilizer = FertilizerResult(id: el.fertilizer_id, nameFertilizer: el.name, priceFertilizer: el.price, massFertilizer: el.mass, typeTree: el.name_type, nameSupplier: el.name_supplier)
                self?.fertilizerData.append(newFertilizer)
            }
            self?.status = true
        }
    }
}
