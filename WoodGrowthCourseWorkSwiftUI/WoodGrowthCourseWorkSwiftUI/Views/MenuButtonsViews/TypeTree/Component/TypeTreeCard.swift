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
    @Binding var typesData : [TypeTreesResult]
    @Binding var selectedType : String
    @State private var currentIndex = 0
    
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
            }
            
            HStack {
                Image(selectedType)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 200, height: 200)
                    .overlay {
                        Circle().stroke(getGradient(), lineWidth: 3)
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0...10, id: \.self) { _ in
                        TreeCard(treeInfo: TreeResult(id: "0", name_tree: "2", volume: 100, date_measurements: "2023-02-14T21:00:00.000Z", notes: nil, name_type: selectedType, name_plot: "А", x_begin: 0, x_end: 0, y_begin: 10, y_end: 20))
                    }
                }
            }
            .padding(.top, 50)
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
        
        TypeTreeCard(typesData: .constant([item1, item2, item3, item4, item5]), selectedType: .constant("Дуб"))
    }
}
