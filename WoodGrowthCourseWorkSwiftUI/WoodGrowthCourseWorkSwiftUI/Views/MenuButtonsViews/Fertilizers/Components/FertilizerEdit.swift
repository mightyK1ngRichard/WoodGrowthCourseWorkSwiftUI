//
//  FertilizerEdit.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI
import Combine

struct FertilizerEdit: View {
    @EnvironmentObject var allFertilizer : FertilizerData
    @State private var fertilizerName    = ""
    @State private var fertilizerPrice   = ""
    @State private var fertilizerMass    = ""
    @State private var typeTree          = ""
    @State private var textInAlert       = ""
    @State private var showAlert         = false
    @State private var isHover           = false
    @State private var isShowView        = true
    @Binding var close                   : EditOrAdd
    @State private var allTypeOfTrees    : [RowsAllTypeTrees]?
    
    var body: some View {
        VStack {
            if isShowView && allFertilizer.currentCard != nil {
                MainView
            } else {
                ProgressView()
            }
        }
        .onReceive(allFertilizer.$currentCard) { _ in
            fetchAllTypes()
        }
        
    }
    
    private func loadData() {
        if let fname = allFertilizer.currentCard?.nameFertilizer, let fprice = allFertilizer.currentCard?.priceFertilizer, let fmass = allFertilizer.currentCard?.massFertilizer {
            self.fertilizerName = fname
            self.fertilizerPrice = "\(fprice)"
            self.fertilizerMass = "\(fmass)"
        } else {
            self.close = .none
        }

        if let typeID = allFertilizer.currentCard?.type_id {
            self.typeTree = typeID
            
        } else {
            /// Блок, если нету удобрения.
            if allTypeOfTrees?.count != 0 {
                self.typeTree = allTypeOfTrees![0].type_id
                
            } else {
                isShowView = false
            }
        }
    }
    
    private var MainView: some View {
        VStack {
            if let typeOfTrees = allTypeOfTrees {
                closeScreenButton
                Spacer()
                inputData(dataTypes: typeOfTrees)
                    .task {
                        typeTree = typeOfTrees[0].type_id
                    }
                
                Spacer()
                
            } else {
                Text("Ошибка")
            }
        }
        .padding()
        .frame(width: 400, height: 300)
        .background(getGradient().opacity(0.1))
        .cornerRadius(15)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(getGradient().opacity(0.7), lineWidth: 3)
        }
        .alert(textInAlert, isPresented: $showAlert) {}
    }
    
    private var closeScreenButton: some View {
        Image(systemName: "x.circle")
            .frame(maxWidth: .infinity, alignment: .trailing)
            .foregroundColor(isHover ? .red : .white)
            .onHover { hovering in
                isHover = hovering
            }
            .onTapGesture {
                self.close = .none
            }
    }
    
    private func inputData(dataTypes: [RowsAllTypeTrees]) -> some View {
        VStack {
            MyTextField(textForUser: "Новое название удобрения", text: $fertilizerName)
            MyTextField(textForUser: "Новая цена", text: $fertilizerPrice)
            MyTextField(textForUser: "Новая масса", text: $fertilizerMass)
            
            HStack {
                Text("Вид дерева")
                    .foregroundColor(.gray)
                Spacer()
                Picker("", selection: $typeTree) {
                    ForEach(dataTypes, id: \.self.type_id) { type in
                        Text(type.name_type)
                    }
                }
                .labelsHidden()
                .frame(width: 100)
            }
            
            Button(action: {
                if let currentID = allFertilizer.currentCard?.id {
                    let sqlString = "UPDATE fertilizer SET name='\(fertilizerName)',mass='\(fertilizerMass)',price='\(fertilizerPrice)',type_tree_id='\(typeTree)' WHERE fertilizer_id='\(currentID)';"
                    pullFertilizer(sqlString: sqlString)
                    
                } else {
                    self.showAlert = true
                    self.textInAlert = "Неизвестная ошибка. Мб полетела БД."
                    return
                }
                
                
            }) {
                Text("Save")
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private func fetchAllTypes() {
        APIManager.shared.getTypeOfTreesWithoutFertilizers { data, error in
            guard let data = data else {
                print("== ERROR FROM FertilizerEdit func[fetchAllTypes]:", error!)
                return
            }
            if let typeID = allFertilizer.currentCard?.type_id, let typeName = allFertilizer.currentCard?.typeTree {
                self.allTypeOfTrees = [RowsAllTypeTrees(type_id: typeID, name_type: typeName)] + data.rows
            } else {
                self.allTypeOfTrees = data.rows
            }
        
            loadData()
        }
    }
    
    private func pullFertilizer(sqlString: String) {
        APIManager.shared.updateWithSlash(SQLQuery: sqlString) { data, error in
            if let _ = data {
                self.textInAlert = "Данные некорректны. Вводите положительные числа!"
                self.showAlert = true
                return
                
            }
            self.allFertilizer.refresh()
            self.close = .none
        }
    }
}

struct FertilizerEdit_Previews: PreviewProvider {
    static var previews: some View {
        let allFertilizer = FertilizerData()
        
        FertilizerEdit(close: .constant(.editFertilizer))
            .environmentObject(allFertilizer)
            .onAppear() {
                allFertilizer.currentCard = startFertilizer
            }
    }
}

let startFertilizer = FertilizerResult(id: "1", nameFertilizer: "Удобрения Test", priceFertilizer: 100, massFertilizer: 100, typeTree: "Дерево", type_id: "1", nameSupplier: "Леруа Мерлен", photo: URL(string: "https://vsegda-pomnim.com/uploads/posts/2022-04/1649619470_19-vsegda-pomnim-com-p-palmi-foto-22.jpg")!)
