//
//  CardsTrees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import Foundation

class treesCardsViewModel: ObservableObject {
    /// Получаем данные из БД по деревьям.
    @Published var parseStatus = true
    @Published var treesInfo: [TreeResult] = []
    
    init() {
        refresh()
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.parseStatus = false
        }
        
        APIManager.shared.getTrees { data, error in
            guard let data = data else {
                print("==> ERROR treesCardsViewModel: ", error!)
                DispatchQueue.main.async {
                    self.parseStatus = false
                }
                return
            }
            
            var tempData: [TreeResult] = []
            for el in data.rows {
                let newTree = TreeResult(id: el.tree_id, name_tree: el.name_tree, volume: el.volume, date_measurements: el.date_measurements, notes: el.notes, name_type: el.name_type, name_plot: el.name_plot, x_begin: el.x_begin, x_end: el.x_end, y_begin: el.y_begin, y_end: el.y_end, photo: el.photo, typeID: el.type_id)
                tempData.append(newTree)
            }
            self.treesInfo = tempData
            self.parseStatus = true
        }
    }
    
}

class PressedButtonTree: ObservableObject {
    @Published var pressed                  = false
    @Published var treeInfo: TreeResult?    = nil
}
