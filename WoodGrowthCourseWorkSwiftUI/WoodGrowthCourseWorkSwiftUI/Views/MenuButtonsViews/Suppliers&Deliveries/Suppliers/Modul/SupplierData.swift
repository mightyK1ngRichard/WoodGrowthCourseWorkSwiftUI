//
//  SupplierData.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import Foundation

class SupplierData: ObservableObject {
    @Published var supplierData = [SupplierResult]()
    @Published var status       = false
    
    init() {
        refresh()
    }
    
    func refresh() {
        APIManager.shared.getSupplier { data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                self.status = false
                return
            }
            var tempData: [SupplierResult] = []
            for el in data.rows {
                let info = SupplierResult(id: el.supplier_id, name_supplier: el.name_supplier, telephone: el.telephone, www: el.www, photo: el.photo)
                tempData.append(info)
            }
            self.supplierData = tempData
            self.status = true
        }
    }
}
