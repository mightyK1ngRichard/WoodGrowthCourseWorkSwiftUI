//
//  AddTreeForType.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 15.04.2023.
//

import SwiftUI

struct AddTreeForType: View {
    @EnvironmentObject var treesOfThisType : ListTrees
    @EnvironmentObject var typeData        : TypeTreesData
    @EnvironmentObject var typeList        : ListTypeTrees
    @EnvironmentObject var currentType     : CurrentType
    @Binding var closeScreen               : pressedButton
    @State private var isHover             = false
    @State private var showAlert           = false
    @State private var isShowMainView      = false
    @State private var textInAlert         = ""
    @State private var nameTree            = ""
    @State private var volumTree           = ""
    @State private var notesTree           = ""
    @State private var newTypeTree         = ""
    @State private var XBegin              = ""
    @State private var YBegin              = ""
    @State private var XEnd                = ""
    @State private var YEnd                = ""
    @State private var dateMeasurements    = Date()
    
    var body: some View {
        VStack {
            if isShowMainView {
                mainView()
                
            } else {
                secondView()
            }
        }
            .onAppear() {
                if self.typeList.types.count != 0 {
                    
                    self.newTypeTree = self.currentType.currentType.id
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
                .frame(width: 500, height: 600)
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
            Text(textInAlert)
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
            MyTextField(textForUser: "Имя дерева", text: $nameTree)
            MyTextField(textForUser: "Объём", text: $volumTree)
         
            HStack {
                Image(systemName: "location.circle.fill")
                    .resizable().frame(width: 15, height: 15)
                Text("Координаты:")
            }
            
            HStack {
                MyTextField(textForUser: "X начала", text: $XBegin)
                MyTextField(textForUser: "Y начала", text: $YBegin)
            }
            
            HStack {
                MyTextField(textForUser: "X конца", text: $XEnd)
                MyTextField(textForUser: "Y конца", text: $YEnd)
            }
            
            HStack {
                Image(systemName: "list.bullet.clipboard")
                Text("Примичание к дереву:")
            }
            
            TextEditor(text: $notesTree)
                .foregroundColor(Color.white)
                .font(.custom("HelveticaNeue", size: 13))
                .lineSpacing(5)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            
            HStack {
                Text("Вид дерева")
                Spacer()
                Image(systemName: "square.stack.3d.up.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Picker("", selection: $newTypeTree) {
                    ForEach(typeList.types) {
                        Text($0.nameType)
                    }
                }
                .labelsHidden()
                .frame(width: 140)
            }
            
            HStack {
                Text("Дата посадки")
                Spacer()
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .offset(x: 12)
                
                DatePicker("", selection: $dateMeasurements, in: ...Date())
                    .frame(width: 150)
            }
            
            Button("Save") {
                if nameTree == "" || volumTree == "" || XBegin == "" || XEnd == "" || YBegin == "" || YEnd == "" {
                    self.textInAlert = "Заполните все данные!"
                    self.showAlert = true
                    return
                }
                
                let sqlString = """
                BEGIN TRANSACTION;
                INSERT INTO tree (name_tree, volume, date_measurements, notes, type_tree_id)
                VALUES ('\(nameTree)', \(volumTree), '\(correctDateWithTime(dateMeasurements))', \(notesTree == "" ? "NULL" : "'\(notesTree)'"), \(newTypeTree));
                INSERT INTO coordinates (tree_id, x_begin, x_end, y_begin, y_end)
                VALUES (currval('tree_tree_id_seq'), \(XBegin), \(XEnd), \(YBegin), \(YEnd));
                COMMIT;
                """
                APIRequest(sqlString)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top)
            
        }
    }
    
    private func APIRequest(_ sqlString: String) {
        APIManager.shared.updateWithSlash(SQLQuery: sqlString) { data, error in
            if let _ = data {
                self.textInAlert = "При заполнении базы данных произошла ошибка. Данные некорректны, перепроверьте их!"
                self.showAlert = true
                return
            }
            
            treesOfThisType.refresh(typeID: currentType.currentType.id)
            typeData.refresh { _, _ in
                let currentIndex = getDetailInfoUsingTypeName(data: typeData.types, key: currentType.selectedTypeInPicker)
                DispatchQueue.main.async  {
                    self.currentType.currentType = typeData.types[currentIndex]
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
        let default1 = ListTrees()
        let default2 = TypeTreesData()
        let default3 = ListTypeTrees()
        let default4 = CurrentType()
        
        AddTreeForType(closeScreen: .constant(.main))
            .environmentObject(default1)
            .environmentObject(default2)
            .environmentObject(default3)
            .environmentObject(default4)
    }
}
