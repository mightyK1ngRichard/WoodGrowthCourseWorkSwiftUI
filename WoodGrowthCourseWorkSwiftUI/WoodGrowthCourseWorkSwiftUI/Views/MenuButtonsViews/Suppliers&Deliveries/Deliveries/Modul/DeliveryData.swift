//
//  DeliveryData.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import Foundation

class DeliveryData: ObservableObject {
    @Published var deliveryData: [DeliveryResult] = []
    
    init() {
        APIManager.shared.getDeliveries { data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                return
            }
            for el in data.rows {
                let info = DeliveryResult(id: el.delivery_id, dateDelivery: el.date_delivery, numbersPackets: el.numbers_packets, priceOrder: el.price_order, supplierName: el.name_supplier, fertilizerName: el.name)
                self.deliveryData.append(info)
            }
        }
    }
}
