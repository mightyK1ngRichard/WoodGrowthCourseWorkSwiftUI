//
//  TypeTreesModul.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import Foundation


class TypeTreesData: ObservableObject {
    @Published var types  : [TypeTreesResult] = [
        TypeTreesResult(id: "0", nameType: "Берёза", notes: nil, firtilizerName: nil, plotName: "А", countTrees: "100", photo: URL(string: "https://pibig.info/uploads/posts/2022-11/thumbs/1669748719_24-pibig-info-p-palmovie-krasivo-28.jpg")!)
    ]
    @Published var status = false
    
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
    @Published var types  : [AllTypeTreesResult] = [
        // Для вёрстки.
        AllTypeTreesResult(id: "1", nameType: "Берёза"),
        AllTypeTreesResult(id: "2", nameType: "Берёза"),
        AllTypeTreesResult(id: "3", nameType: "Берёза"),
        AllTypeTreesResult(id: "4", nameType: "Берёза"),
    ]
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

class CurrentType: ObservableObject {
    @Published var currentType = TypeTreesResult(id: "1", nameType: "B", notes: "", firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100", photo: URL(string: "https://phonoteka.org/uploads/posts/2021-05/1621391291_26-phonoteka_org-p-luntik-fon-27.jpg")!)
    @Published var selectedTypeInPicker = "0"
}

func getDetailInfoUsingTypeName(data: [TypeTreesResult], key: String) -> Int {
    return data.firstIndex { $0.id == key }!
}
