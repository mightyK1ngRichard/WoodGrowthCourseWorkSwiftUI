//
//  AddendumSupplier.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 21.04.2023.
//

import SwiftUI

struct AddendumSupplier: View {
    @EnvironmentObject var supplierData : SupplierData
    @Binding var close                  : Bool
    @State private var newName          = ""
    @State private var newPhone         = ""
    @State private var newWWW           = ""
    @State private var newPhoto         = ""
    @State private var textInAlert      = ""
    @State private var isHover          = false
    @State private var showAlert        = false
    
    var body: some View {
        MainView
            .alert(textInAlert, isPresented: $showAlert) {}
    }
    
    private var closeView: some View {
        Image(systemName: "x.circle")
            .onHover { hovering in
                self.isHover = hovering
            }
            .onTapGesture {
                self.close = false
            }
            .foregroundColor(isHover ? .yellow : .white)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var MainView: some View {
        VStack {
            closeView
            
            Text("Добавление поставщика:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
                .padding(.vertical)
            
            MyTextField(textForUser: "Назавание поставщика", text: $newName)
            MyTextField(textForUser: "Телефон поставщика", text: $newPhone)
            MyTextField(textForUser: "Фото поставщика (не обязательно)", text: $newPhoto)
            MyTextField(textForUser: "Сайт поставщика (не обязательно)", text: $newWWW)

            Button(action: {
                if newName == "" || newPhone == "" {
                    self.textInAlert = "Имя и телофон должны содержать информацию!"
                    self.showAlert = true
                    return
                }
                
                /// Если ссылку на фото ввели.
                if newPhoto != "" {
                    guard let link = URL(string: newPhoto) else {
                        self.textInAlert = "Ссылка некорректна!"
                        self.showAlert = true
                        return
                    }
                    
                    /// Проверка фото на корректность ссылки.
                    isPhotoURLValid(url: link) { isValid in
                        if isValid {
                            let sqlString = "INSERT INTO supplier (name_supplier, telephone, www, photo) VALUES ('\(newName)', '\(newPhone)', \(newWWW == "" ? "NULL" : "'\(newWWW)'"), '\(link)');"
                            pullData(SQLQuery: sqlString)
                            
                        } else {
                            self.textInAlert = "Приложение не может обработать ссылку на эту фоторграфию. Предоставьте другую ссылку."
                            self.showAlert = true
                            return
                        }
                    }
                } else {
                    /// Если фото не ввели.
                    let sqlString = "INSERT INTO supplier (name_supplier, telephone, www, photo) VALUES ('\(newName)', '\(newPhone)', \(newWWW == "" ? "NULL" : "'\(newWWW)'"), NULL);"
                    pullData(SQLQuery: sqlString)
                }
                
            }, label: {
                Text("Добавить")
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.3))
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20).stroke(Color(hexString: "#EC2301"), lineWidth: 1)
                    }
            })
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(.black)
        .frame(width: 500)
        .cornerRadius(20)
        .shadow(color: Color(red: 176/255, green: 0, blue: 0), radius: 10)
    }
    
    private func pullData(SQLQuery: String) {
        APIManager.shared.updateWithSlash(SQLQuery: SQLQuery) { resp, error in
            guard let _ = resp else {
                DispatchQueue.main.async {
                    self.supplierData.refresh()
                    self.close = false
                }
                return
            }
            DispatchQueue.main.async {
                self.textInAlert = "Не получилось добавить поставщика. Возможно проблема с ссылкой на фото."
                self.showAlert = true
            }
            
        }
    }
}

struct AddendumSupplier_Previews: PreviewProvider {
    static var previews: some View {
        AddendumSupplier(close: .constant(false))
    }
}
