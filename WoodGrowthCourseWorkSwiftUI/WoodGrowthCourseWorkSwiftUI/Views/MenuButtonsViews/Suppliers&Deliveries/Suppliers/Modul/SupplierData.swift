//
//  SupplierData.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import Foundation

class SupplierData: ObservableObject {
    @Published var supplierData : [SupplierResult] = []
    @Published var status       = false
    
    init() {
        APIManager.shared.getSupplier {[weak self] data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                self?.status = false
                return
            }
            for el in data.rows {
                let info = SupplierResult(id: el.supplier_id, name_supplier: el.name_supplier, telephone: el.telephone, www: el.www, photo: el.photo)
                self?.supplierData.append(info)
            }
            self?.status = true
        }
    }
}
