//
//  AddEmployee.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 13.04.2023.
//

import SwiftUI

struct AddEmployee: View {
    @State private var isHover      = false
    @State private var showAlert    = false
    @State private var textInAlert  = ""
    @State private var newFullName  = ""
    @State private var newPost      = ""
    @State private var newPhone     = ""
    @State private var newPhotoLink = ""
    @Binding var closeScreen        : Bool
    @EnvironmentObject var allData  : employeesCardsViewModel
    
    
    var body: some View {
        VStack {
            Text("Добавление работника.")
                .font(.system(size: 40))
                .bold()
            
            HStack {
                Spacer()
                VStack {
                    closeCard()
                    Spacer()
                    inputDataView()
                }
                .padding()
                .frame(width: 500, height: 400)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(getGradient(), lineWidth: 3)
                }
                
                Spacer()
            }
        }
        .alert("Ошибка", isPresented: $showAlert, actions: {
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
                .padding(.trailing, 0)
                .padding(.top, 10)
                .onTapGesture {
                    closeScreen = false
                }
                .onHover { hovering in
                    isHover = hovering
                }
        }
    }
    
    private func inputDataView() -> some View {
        VStack {
            Spacer()
            MyTextField(textForUser: "Введите имя", text: $newFullName)
            MyTextField(textForUser: "Введите должность", text: $newPost)
            MyTextField(textForUser: "Введите телефон", text: $newPhone)
            MyTextField(textForUser: "Введите ссылку на фото", text: $newPhotoLink)
            
            Button {
                if newFullName == "" && newPost == "" && newPhone == "" {
                    self.textInAlert = "Заполните данные."
                    self.showAlert = true
                    return
                }
                
                guard let link = URL(string: newPhotoLink) else {
                    self.textInAlert = "Вводите ссылку на фото! А не что-то там другое."
                    self.showAlert = true
                    return
                }
                
                isPhotoURLValid(url: link) { isValid in
                    if isValid {
                        var SQLQuery = "INSERT INTO employer (full_name, post, phone_number, photo) VALUES ('\(newFullName)', '\(newPost)', '\(newPhone)'"
                        
                        if newPhotoLink != "" {
                            SQLQuery += ", '\(newPhotoLink)');"
                        } else {
                            SQLQuery += ", NULL);"
                        }
                        updateData(SQLQuery)
                        
                    } else {
                        self.textInAlert = "Приложение не может обработать ссылку на это фото! Введите другую ссылку!"
                        self.showAlert = true
                        return
                    }
                }
                
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                        .padding(.trailing)
                }
            }
            .padding(.top)
            .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer()
        }
    }
    
    private func updateData(_ SQLQuery: String) {
        APIManager.shared.updateWithSlash(SQLQuery: SQLQuery) { data, error in
            if let _ = data {
                self.textInAlert = "При заполнении базы данных произошла ошибка. Данные некорректны, перепроверьте их!"
                self.showAlert = true
                return

            }
            
            self.allData.refresh()
            self.closeScreen = false
        }
    }
    
}

struct AddEmployee_Previews: PreviewProvider {
    static var previews: some View {
        AddEmployee(closeScreen: .constant(false))
    }
}
