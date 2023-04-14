//
//  TypeTreesModul.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import Foundation


class TypeTreesData: ObservableObject {
    @Published var types: [TypeTreesResult] = []
    @Published var status                   = false
    
    init() {
        refresh()
    }
    
    func refresh() {
        APIManager.shared.getTypesTrees {data, error in
            guard let data = data else {
                print("== ERROR", error!)
                self.status = false
                return
            }
            var tempData: [TypeTreesResult] = []
            for el in data.rows {
                let info = TypeTreesResult(id: el.type_id, nameType: el.name_type, notes: el.notes, firtilizerName: el.fertilizer_name, plotName: el.plot_name, countTrees: el.count_trees, photo: el.photo)
                tempData.append(info)
            }
            
            DispatchQueue.main.async {
                self.types = tempData
                self.status = true
            }
        }
    }
}
