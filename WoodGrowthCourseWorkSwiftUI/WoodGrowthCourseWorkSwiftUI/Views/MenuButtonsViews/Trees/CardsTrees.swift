//
//  CardsTrees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import Foundation

class treesCardsViewModel: ObservableObject {
    // Получаем данные из БД по деревьям.
    
    @Published var treesInfo: [TreeResult] = []
    
    init() {
        APIManager.shared.getTrees { data, error in
            guard let data = data else {
                print("==> ERROR with data in API\n", error!)
                return
            }
            for el in data.rows {
                let newTree = TreeResult(id: el.tree_id, name_tree: el.name_tree, volume: el.volume, date_measurements: el.date_measurements, notes: el.notes, name_type: el.name_type, name_plot: el.name_plot, x_begin: el.x_begin, x_end: el.x_end, y_begin: el.y_begin, y_end: el.y_end)
                self.treesInfo.append(newTree)
            }
            
        }
    }
        
}