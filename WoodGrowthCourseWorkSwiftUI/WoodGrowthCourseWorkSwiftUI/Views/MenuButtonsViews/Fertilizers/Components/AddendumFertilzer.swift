//
//  AddendumFertilzer.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 19.04.2023.
//

import SwiftUI

struct AddendumFertilzer: View {
    
    @EnvironmentObject var allFertilizer : FertilizerData
    @State private var fertilizerName    = ""
    @State private var fertilizerPrice   = ""
    @State private var fertilizerMass    = ""
    @State private var typeTree          = ""
    @State private var textInAlert       = ""
    @State private var isHover           = false
    @State private var showAlert           = false
    @State private var isShowView        = true
    @Binding var close                   : EditOrAdd
    @State private var allTypeOfTrees    : [RowsAllTypeTrees]?
    
    var body: some View {
        MainView
            .onAppear() {
                fetchAllTypes()
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
                if fertilizerName == "" || fertilizerPrice == "" || fertilizerMass == "" || typeTree == "" {
                    self.textInAlert = "Заполните все данные!"
                    self.showAlert = true
                    return
                }
                
                let sqlString = "INSERT INTO fertilizer (name, price, mass, type_tree_id) VALUES ('\(fertilizerName)','\(fertilizerPrice)','\(fertilizerMass)','\(typeTree)');"
                pullFertilizer(SQLQuery: sqlString)
                
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                        .padding(.trailing, 5)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 5)
            .padding(.vertical, 4)
            .background(Color(red: 3/255, green: 109/255, blue: 251/255))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
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
    
    private func fetchAllTypes() {
        APIManager.shared.getTypeOfTreesWithoutFertilizers { data, error in
            guard let data = data else {
                print("== ERROR FROM FertilizerEdit func[fetchAllTypes]:", error!)
                return
            }
            self.allTypeOfTrees = data.rows
        }
    }
    
    private func pullFertilizer(SQLQuery: String) {
        APIManager.shared.updateWithSlash(SQLQuery: SQLQuery) { data, error in
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

struct AddendumFertilzer_Previews: PreviewProvider {
    static var previews: some View {
        AddendumFertilzer(close: .constant(.addFertilizer))
    }
}
