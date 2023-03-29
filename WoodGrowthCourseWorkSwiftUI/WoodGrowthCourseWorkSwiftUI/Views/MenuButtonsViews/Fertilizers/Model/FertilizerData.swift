//
//  FertilizerData.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import Foundation

class FertilizerData: ObservableObject {
    @Published var fertilizerData: [FertilizerResult] = []
    
    init() {
        APIManager.shared.getFertilizer { data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                return
            }
            for el in data.rows {
                let newFertilizer = FertilizerResult(id: el.fertilizer_id, nameFertilizer: el.name, priceFertilizer: el.price, massFertilizer: el.mass, typeTree: el.name_type, nameSupplier: el.name_supplier)
                self.fertilizerData.append(newFertilizer)
            }
        }
    }
}

