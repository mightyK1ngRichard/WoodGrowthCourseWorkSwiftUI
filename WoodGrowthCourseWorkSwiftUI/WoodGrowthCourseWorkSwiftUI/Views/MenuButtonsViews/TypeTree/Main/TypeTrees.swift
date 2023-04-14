//
//  TypeTrees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI

struct TypeTrees: View {
    //@ObservedObject var typesData = TypeTreesData()
    @State private var showScreen   = false
    @State private var typesData    : [TypeTreesResult] = []
    @State private var selectedType = ""
    
    var body: some View {
        HStack {
            if !showScreen {
                TurnOffServer()
                
            } else {
                TypeTreeCard(typesData: $typesData, selectedType: $selectedType)
            }
        }
        //.environmentObject(typesData)
        .frame(minWidth: 600, minHeight: 600)
        .onAppear {
            getData()
        }
    }
    
    private func getData() {
        APIManager.shared.getTypesTrees {data, error in
            guard let data = data else {
                print("== ERROR", error!)
                return
            }
            
            var tempData: [TypeTreesResult] = []
            for el in data.rows {
                let info = TypeTreesResult(id: el.type_id, nameType: el.name_type, notes: el.notes, firtilizerName: el.fertilizer_name, plotName: el.plot_name, countTrees: el.count_trees, photo: el.photo)
                tempData.append(info)
            }
            
            if tempData.count != 0 {
                self.typesData = tempData
                self.selectedType =  tempData[0].nameType
                self.showScreen = true
            }
        }
    }
}

struct TypeTrees_Previews: PreviewProvider {
    static var previews: some View {
        TypeTrees()
    }
}
