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
        refresh() { _, _ in }
    }
    
    func refresh(completion: @escaping ([TypeTreesResult]?, String?) -> Void) {
        APIManager.shared.getTypesTrees {data, error in
            guard let data = data else {
                print("== ERROR FROM TypeTreesModul", error!)
                self.status = false
                completion(nil, error!)
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
                completion(tempData, nil)
            }
        }
    }
}

class ListTypeTrees: ObservableObject {
    @Published var types  : [AllTypeTreesResult] = []
    @Published var status = false
    
    init() {
        refresh()
    }
    
    func refresh() {
        APIManager.shared.getAllTypeTreesWithoutConditions {data, error in
            guard let data = data else {
                print("== ERROR FROM TypeTreesModule", error!)
                DispatchQueue.main.async {
                    self.status = false
                }
                return
            }
            var tempData: [AllTypeTreesResult] = []
            for el in data.rows {
                let info = AllTypeTreesResult(id: el.type_id, nameType: el.name_type)
                tempData.append(info)
            }
            
            DispatchQueue.main.async {
                self.types = tempData
                self.status = true
            }
        }
    }
}

class ListTrees: ObservableObject {
    @Published var trees  : [TreeResult] = []
    
    func refresh(typeID: String) {
        APIManager.shared.getTrees(typeID: typeID) { data, error in
            guard let data = data else {
                print("== ERROR", error!)
                return
            }
            var tempData: [TreeResult] = []
            for el in data.rows {
                let info = TreeResult(id: el.tree_id, name_tree: el.name_tree, volume: el.volume, date_measurements: el.date_measurements, notes: el.notes, name_type: el.name_type, name_plot: el.name_plot, x_begin: el.x_begin, x_end: el.x_end, y_begin: el.y_begin, y_end: el.y_end, photo: el.photo)
                    tempData.append(info)
            }
            DispatchQueue.main.async {
                self.trees = tempData
            }
            
        }
    }
}
