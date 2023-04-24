//
//  EditTypeTree.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 15.04.2023.
//

import SwiftUI

struct EditTypeTree: View {
    @EnvironmentObject var typeData    : TypeTreesData
    @EnvironmentObject var currentType : CurrentType
    @Binding var closeScreen           : pressedButton
    @State private var isHover         = false
    @State private var showAlert       = false
    @State private var showMainView    = false
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
            
            Text("Редактирование вида.")
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
                        .stroke(Color(hexString: "#EC2301"), lineWidth: 3)
                }
                .background(.black.opacity(0.5))
                .cornerRadius(20)
                Spacer()
            }
            
            Spacer()
        }
        .onReceive(currentType.$currentType) { newValue in
            self.newNameType = currentType.currentType.nameType
            self.newPhoto = "\(currentType.currentType.photo)"
            self.newNote = currentType.currentType.notes ?? ""
            self.showMainView = true
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
            Spacer()
            Text("Название вида участка.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            
            MyTextFieldBlack(textForUser: "Название участка", text: $newNameType)
                .padding(.top, -7)
            
            Text("URL фото вида участка.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            MyTextFieldBlack(textForUser: "URL фото", text: $newPhoto)
                .padding(.top, -7)
            
            Text("Примечание")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            
            TextEditor(text: $newNote)
                .background(Color.gray.opacity(0.2))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.white)
                .font(.system(size: 16))
                .padding(.top, -7)
            
            Button {
                if newNameType == "" || newPhoto == "" {
                    self.textInAlert = "Заполните все данные!"
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
                        let sqlString = """
                        UPDATE type_tree SET name_type='\(newNameType)',photo='\(link)',notes='\(newNote)' WHERE type_id=\(currentType.currentType.id);
                        """
                        APIRequest(sqlString)
                        
                    } else {
                        self.textInAlert = "Приложение не может обработать ссылку на это фото! Введите другую ссылку!"
                        self.showAlert = true
                        return
                    }
                }
                
            } label: {
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
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top)
            
            Spacer()
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

struct EditTypeTree_Previews: PreviewProvider {
    static var previews: some View {
        let defaultCurrentCard = CurrentType()
        let defaultTypeData = TypeTreesData()
        
        EditTypeTree(closeScreen: .constant(.main))
            .environmentObject(defaultTypeData)
            .environmentObject(defaultCurrentCard)
    }
}
