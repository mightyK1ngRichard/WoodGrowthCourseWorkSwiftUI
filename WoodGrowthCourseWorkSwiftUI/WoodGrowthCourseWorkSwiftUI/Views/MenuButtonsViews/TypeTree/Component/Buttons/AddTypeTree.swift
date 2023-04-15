//
//  AddTypeTree.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 15.04.2023.
//

import SwiftUI

struct AddTypeTree: View {
    @EnvironmentObject var typeData : TypeTreesData
    @Binding var closeScreen        : pressedButton
    @State private var isHover      = false
    @State private var showAlert    = false
    @State private var newNameType  = ""
    @State private var newNote      = ""
    @State private var newPhoto     = ""
    
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        VStack {
            Spacer()
            
            Text("Добавления вида.")
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
            MyTextField(textForUser: "Название участка", text: $newNameType)
            MyTextField(textForUser: "URL фото", text: $newPhoto)
            Text("Примечание")
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
            
            TextEditor(text: $newNote)
                .background(Color.gray.opacity(0.2))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .border(Color.gray)
                .background(Color.white)
                .font(.system(size: 16))
                

            
            Button("Save") {
                if newNameType == "" || newPhoto == "" {
                    self.showAlert = true
                    return
                }
                
                var sqlString = """
                INSERT INTO type_tree (name_type, photo, notes) VALUES ('\(newNameType)', '\(newPhoto)',
                """
                if newNote == "" {
                    sqlString += "NULL);"
                } else {
                    sqlString += "'\(newNote)');"
                }
                
                APIRequest(sqlString)
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
}

struct AddTypeTree_Previews: PreviewProvider {
    static var previews: some View {
        AddTypeTree(closeScreen: .constant(.main))
    }
}
