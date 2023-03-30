//
//  TypeTreeCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI

private func getDetailInfoUsingTypeName(data: [TypeTreesResult], key: String) -> Int {
    return data.firstIndex { $0.nameType == key }!
}

struct TypeTreeCard: View {
    @Binding var typesData             : [TypeTreesResult]
    @Binding var selectedType          : String
    @State private var currentIndex    = 0
    @Binding var treesOfThisType : [TreeResult]
    @State private var showTrees       = true
    @State private var isHover         = false
    @State private var closeEye        = true
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedType) {
                ForEach(typesData, id: \.self.nameType) {
                    Text($0.nameType)
                }
            }
            .pickerStyle(.segmented)
            .padding(.vertical)
            .onChange(of: selectedType) { _ in
                currentIndex = getDetailInfoUsingTypeName(data: typesData, key: selectedType)
                treesOfThisType.removeAll()
                
                if !closeEye {
                    APIManager.shared.getTrees(plotId: typesData[currentIndex].id) { data, error in
                        guard let data = data else {
                            print("== ERROR", error!)
                            self.showTrees = false
                            return
                        }
                        
                        for el in data.rows {
                            let info = TreeResult(id: el.tree_id, name_tree: el.name_tree, volume: el.volume, date_measurements: el.date_measurements, notes: el.notes, name_type: el.name_type, name_plot: el.name_plot, x_begin: el.x_begin, x_end: el.x_end, y_begin: el.y_begin, y_end: el.y_end)
                            self.treesOfThisType.append(info)
                        }
                        self.showTrees = true
                    }
                }
            }
            
            HStack {
                ZStack {
                    Image(selectedType)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        .overlay {
                            Circle().stroke(getGradient(), lineWidth: 3)
                        }
                        .onHover { hovering in
                            isHover = hovering
                        }
                        .brightness(isHover ? -0.6 : 0)
                        
                    if isHover {
                        Image(systemName: closeEye ? "eye.slash" : "eye")
                            .resizable()
                            .frame(width: 120, height: 90)
                            .onHover { hovering in
                                isHover = hovering
                            }
                            .onTapGesture {
                                closeEye.toggle()
                            }
                    }
                }
                
                
                VStack (alignment: .leading, spacing: 5) {
                    Text("\(selectedType)")
                        .font(.system(size: 40))
                    Text("**Удобрение:** \(typesData[currentIndex].firtilizerName)")
                    Text("**Примечание:**")
                    Text("*\(typesData[currentIndex].notes ?? "Описания нету")*")
                    Text("**Количество деревьев:** \(typesData[currentIndex].countTrees) шт.")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
            
            Spacer()
            
            if showTrees {
                if !closeEye {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(treesOfThisType) { tree in
                                TreeCardForTypeTreeView(treeInfo: tree)
                            }
                        }
                    }
                    .padding(.top, 50)
                }

            } else {
                ProgressView()
            }
            
            Spacer()
        }
        .frame(minHeight: 600)
    }
}

struct TypeTreeCard_Previews: PreviewProvider {
    static var previews: some View {
        let item1 = TypeTreesResult(id: "0", nameType: "B", notes: "", firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100")
        let item2 = TypeTreesResult(id: "1", nameType: "O", notes: nil, firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100")
        let item3 = TypeTreesResult(id: "2", nameType: "S", notes: "дорого", firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100")
        let item4 = TypeTreesResult(id: "3", nameType: "S", notes: "дорого", firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100")
        let item5 = TypeTreesResult(id: "4", nameType: "!", notes: "дорого", firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100")
        
        TypeTreeCard(typesData: .constant([item1, item2, item3, item4, item5]), selectedType: .constant("Дуб"), treesOfThisType: .constant([]))
    }
}
