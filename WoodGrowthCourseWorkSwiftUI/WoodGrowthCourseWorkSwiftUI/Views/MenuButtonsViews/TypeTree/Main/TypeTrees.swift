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
    
    var body: some View {
        HStack {
            if !showScreen {
                TurnOffServer()
                
            } else {
                TypeTreeCard(typesData: $typesData, selectedType: $selectedType)
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
                    let info = TypeTreesResult(id: el.type_id, nameType: el.name_type, notes: el.notes, firtilizerName: el.fertilizer_name, plotName: el.plot_name, countTrees: el.count_trees, photo: el.photo)
                    self.typesData.append(info)
                }
                if self.typesData.count != 0 {
                    self.selectedType = self.typesData[0].nameType
                    self.showScreen = true
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
