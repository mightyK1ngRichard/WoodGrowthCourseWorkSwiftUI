//
//  AddEmployee.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 13.04.2023.
//

import SwiftUI

struct AddEmployee: View {
    @State private var isHover      = false
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
                var SQLQuery = "INSERT INTO employer (full_name, post, phone_number, photo) VALUES ('\(newFullName)', '\(newPost)', '\(newPhone)'"
                
                if newPhotoLink != "" {
                    SQLQuery += ", '\(newPhotoLink)');"
                } else {
                    SQLQuery += ", NULL);"
                }
                
                updateData(SQLQuery)
                
                
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
            guard let _ = data else {
                print("== ERROR FROM AddEmployee", error!)
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
