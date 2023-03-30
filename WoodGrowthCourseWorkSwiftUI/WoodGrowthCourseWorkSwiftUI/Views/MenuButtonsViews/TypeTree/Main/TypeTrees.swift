//
//  TypeTrees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI

struct TypeTrees: View {
    @State private var showScreen = false
    @State var typesData: [TypeTreesResult] = []
    @State var selectedType = ""
    @State private var treesOfThisType : [TreeResult] = []
    
    var body: some View {
        HStack {
            if !showScreen {
                TurnOffServer()
                
            } else {
                TypeTreeCard(typesData: $typesData, selectedType: $selectedType, treesOfThisType: $treesOfThisType)
            }
        }
        .frame(minWidth: 600, minHeight: 600)
        .onAppear {
            APIManager.shared.getTypesTrees {data, error in
                guard let data = data else {
                    print("== ERROR", error!)
                    return
                }
                for el in data.rows {
                    let info = TypeTreesResult(id: el.type_id, nameType: el.name_type, notes: el.notes, firtilizerName: el.fertilizer_name, plotName: el.plot_name, countTrees: el.count_trees)
                    self.typesData.append(info)
                }
                if self.typesData.count != 0 {
                    self.selectedType = self.typesData[0].nameType
                    self.showScreen = true
                    
                    APIManager.shared.getTrees(plotId: typesData[0].id) { data, error in
                        guard let data = data else {
                            print("== ERROR", error!)
                            return
                        }
                        
                        for el in data.rows {
                            let info = TreeResult(id: el.tree_id, name_tree: el.name_tree, volume: el.volume, date_measurements: el.date_measurements, notes: el.notes, name_type: el.name_type, name_plot: el.name_plot, x_begin: el.x_begin, x_end: el.x_end, y_begin: el.y_begin, y_end: el.y_end)
                            self.treesOfThisType.append(info)
                        }
                        print("ПАРСИМм")
                    }
                }
            }
            
        }
        
    }
}

struct TypeTrees_Previews: PreviewProvider {
    static var previews: some View {
        TypeTrees()
    }
}
