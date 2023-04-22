//
//  AddTypeTree.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 15.04.2023.
//

import SwiftUI

struct AddTypeTree: View {
    @EnvironmentObject var typeData    : TypeTreesData
    @EnvironmentObject var currentType : CurrentType
    @Binding var closeScreen           : pressedButton
    @State private var isHover         = false
    @State private var showAlert       = false
    @State private var textInAlert     = ""
    @State private var newNameType     = ""
    @State private var newNote         = ""
    @State private var newPhoto        = ""
    
    
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
            Text(textInAlert)
        })
        .padding()
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
            MyTextField(textForUser: "Название участка", text: $newNameType)
            MyTextField(textForUser: "URL фото", text: $newPhoto)
            Text("Примечание")
                .frame(maxWidth: .infinity, alignment: .leading)
                .bold()
            
            TextEditor(text: $newNote)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.white)
                .font(.system(size: 14))
            
            Button("Save") {
                if newNameType == "" || newPhoto == "" {
                    self.textInAlert = "Имя или URL не найдены. Заполните данные."
                    self.showAlert = true
                    return
                }
                
                guard let link = URL(string: newPhoto) else {
                    self.textInAlert = "Вводите ссылку на фото! А не что-то там другое."
                    self.showAlert = true
                    return
                }
                
                isPhotoURLValid(url: link) { isValid in
                    if isValid {
                        var sqlString = """
                        INSERT INTO type_tree (name_type, photo, notes) VALUES ('\(newNameType)', '\(newPhoto)',
                        """
                        if newNote == "" {
                            sqlString += "NULL);"
                        } else {
                            sqlString += "'\(newNote)');"
                        }
                        APIRequest(sqlString)
                        
                    } else {
                        self.textInAlert = "Приложение не может обработать ссылку на это фото! Введите другую ссылку!"
                        self.showAlert = true
                        return
                    }
                }
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top)
        }
    }
    
    private func APIRequest(_ sqlString: String) {
        APIManager.shared.updateWithSlash(SQLQuery: sqlString) { data, error in
            if let _ = data {
                DispatchQueue.main.async {
                    self.textInAlert = "При заполнении базы данных произошла ошибка. Данные некорректны, перепроверьте их!"
                    self.showAlert = true
                }
                return
                
            }

            typeData.refresh { _, _ in
                let currentIndex = getDetailInfoUsingTypeName(data: typeData.types, key: currentType.selectedTypeInPicker)
                DispatchQueue.main.async  {
                    self.currentType.currentType = typeData.types[currentIndex]
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
