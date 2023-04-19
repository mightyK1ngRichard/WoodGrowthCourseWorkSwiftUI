//
//  FertilizerData.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import Foundation

class FertilizerData: ObservableObject {
    @Published var fertilizerData : [FertilizerResult] = []
    @Published var currentCard    : FertilizerResult?
    @Published var status         = true
    
    init() {
        refresh()
    }
    
    func refresh() {
        self.status = false
        APIManager.shared.getFertilizer { [weak self] data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                self?.status = false
                return
            }
            var tempData: [FertilizerResult] = []
            for el in data.rows {
                let newFertilizer = FertilizerResult(id: el.fertilizer_id, nameFertilizer: el.name, priceFertilizer: el.price, massFertilizer: el.mass, typeTree: el.name_type, type_id: el.type_id, nameSupplier: el.name_supplier, photo: el.photo)
                tempData.append(newFertilizer)
            }
            
            self?.fertilizerData = tempData
            self?.status = true
        }
    }
}
