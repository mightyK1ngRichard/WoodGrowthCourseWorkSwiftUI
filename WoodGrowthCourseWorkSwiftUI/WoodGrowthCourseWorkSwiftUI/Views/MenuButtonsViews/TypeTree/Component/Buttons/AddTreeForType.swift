//
//  AddTreeForType.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 15.04.2023.
//

import SwiftUI

struct AddTreeForType: View {
    @EnvironmentObject var typeData     : TypeTreesData
    @Binding var closeScreen            : pressedButton
    @Binding var treesOfThisType        : [TreeResult]
    @State private var isHover          = false
    @State private var showAlert        = false
    @State private var isShowMainView   = false
    @State private var nameTree         = ""
    @State private var volumTree        = ""
    @State private var newTypeTree      = ""
    @State private var dateMeasurements = Date()
    var typeList                        : [AllTypeTreesResult]
    
    var body: some View {
        mainView()
            .onAppear() {
                if self.typeList.count != 0 {
                    self.newTypeTree = self.typeList[0].id
                    print("===newTypeTree", self.typeList[0].id)
                    self.isShowMainView = true

                } else {
                    self.isShowMainView = false
                }
            }
    }
    
    private func mainView() -> some View {
        VStack {
            Spacer()
            
            Text("Создание дерева.")
                .font(.system(size: 40))
                .bold()
            
            HStack {
                Spacer()
                VStack {
                    closeCard()
                    inputDataView()
                }
                .padding()
                .frame(width: 500, height: 400)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(getGradient(), lineWidth: 3)
                }
                .background(getGradient().opacity(0.05))
                .cornerRadius(20)
                Spacer()
            }
            
            Spacer()
        }
        .alert("Ошибка!", isPresented: $showAlert, actions: {
            Button("OK") { }
        }, message: {
            Text("Заполните данные.")
        })
    }
    
    private func closeCard() -> some View {
        HStack {
            Spacer()
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(isHover ? .red : .white)
                .onTapGesture {
                    closeScreen = .main
                }
                .onHover { hovering in
                    isHover = hovering
                }
                .padding(.bottom, 10)
        }
        
    }
    
    private func inputDataView() -> some View {
        VStack {
            Spacer()
            MyTextField(textForUser: "Имя дерева", text: $nameTree)
            MyTextField(textForUser: "Объём", text: $volumTree)
            HStack {
                Text("Дата посадки")
                Spacer()
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                DatePicker("", selection: $dateMeasurements, in: ...Date())
                    .frame(width: 150)
            }
            
            HStack {
                Text("Вид дерева")
                Spacer()
                Picker("", selection: $newTypeTree) {
                    ForEach(typeList) {
                        Text($0.nameType)
                    }
                }
                .labelsHidden()
                .frame(width: 140)
            }
         
            Button("Save") {
                if nameTree == "" || volumTree == "" {
                    self.showAlert = true
                    return
                }
                
                var sqlString = """
                INSERT INTO type_tree (name_type, photo, notes) VALUES ('', '',
                """
                print(nameTree, volumTree, "\(dateMeasurements)", newTypeTree)
                // APIRequest(sqlString)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top)
            
            Spacer()
        }
    }
    
    private func APIRequest(_ sqlString: String) {
        APIManager.shared.updateWithSlash(SQLQuery: sqlString) { data, error in
            guard let _ = data else {
                print("== ERROR FROM AddTypeTree [Button]<Save>", error!)
                // .... Что-то выводить при ошибке
                return
            }

            DispatchQueue.main.async  {
                typeData.refresh { _, _ in
                    self.closeScreen = .main
                }
            }
        }

    }
    
    private func secondView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Видов деревьев нету.")
                    .font(.system(size: 50))
                Spacer()
            }
            ProgressView()
            Spacer()
        }
    }
}

struct AddTreeForType_Previews: PreviewProvider {
    static var previews: some View {
        let tree1 = TreeResult(id: "0", name_tree: "1", volume: 12, date_measurements: "2023-02-14T21:00:00.000Z", notes: nil, name_type: "Берёза", name_plot: "F", x_begin: 10, x_end: 10, y_begin: 10, y_end: 10, photo: URL(string: "https://klike.net/uploads/posts/2023-01/1674189522_3-98.jpg")!)
        
        AddTreeForType(closeScreen: .constant(.main), treesOfThisType: .constant([tree1, tree1, tree1]), typeList: [AllTypeTreesResult(id: "0", nameType: "Берёза")])
    }
}
