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

            Button("Добавить") {
                if newName == "" || newPhone == "" {
                    self.textInAlert = "Имя и телофон должны содержать информацию!"
                    self.showAlert = true
                    return
                }
                let sqlString = "INSERT INTO supplier (name_supplier, telephone, www, photo) VALUES ('\(newName)', '\(newPhone)', \(newWWW == "" ? "NULL" : "'\(newWWW)'"), \(newPhoto == "" ? "NULL" : "'\(newPhoto)'"));"
                pullData(SQLQuery: sqlString)
            }
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
