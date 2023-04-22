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
        .background(.black.opacity(0.5))
        .cornerRadius(15)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hexString: "#EC2301"), lineWidth: 2)
        }
        .alert(textInAlert, isPresented: $showAlert) {}
    }
    
    private func inputData(dataTypes: [RowsAllTypeTrees]) -> some View {
        VStack {
            MyTextFieldBlack(textForUser: "Название удобрения", text: $fertilizerName)
            MyTextFieldBlack(textForUser: "Цена удобрения", text: $fertilizerPrice)
            MyTextFieldBlack(textForUser: "Масса удобрения", text: $fertilizerMass)
            
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
                Text("Сохранить")
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.3))
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20).stroke(Color(hexString: "#EC2301"), lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .offset(y: 20)
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
                DispatchQueue.main.async {
                    self.textInAlert = "Данные некорректны. Вводите положительные числа!"
                    self.showAlert = true
                }
                return
                
            }
            DispatchQueue.main.async {
                self.allFertilizer.refresh()
                self.close = .none
            }
        }
        
    }
}

struct AddendumFertilzer_Previews: PreviewProvider {
    static var previews: some View {
        AddendumFertilzer(close: .constant(.addFertilizer))
    }
}
