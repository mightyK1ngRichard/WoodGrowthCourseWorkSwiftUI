//
//  SupplierDetail.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import SwiftUI

struct SupplierDetail: View {
    @EnvironmentObject var supplierData : SupplierData
    @Binding var currentData            : SupplierResult?
    @Binding var close                  : Bool
    @State private var inputPassword    = ""
    @State private var newName          = ""
    @State private var newPhone         = ""
    @State private var newWWW           = ""
    @State private var newPhoto         = ""
    @State private var textInAlert      = ""
    @State private var isHover          = false
    @State private var showAlert        = false
    @State private var showAlertDelete  = false
    
    var body: some View {
        MainView
            .onAppear() {
                if let current = currentData {
                    self.newName = current.name_supplier
                    self.newPhone = current.telephone ?? ""
                    if let photo = current.photo {
                        self.newPhoto = "\(photo)"
                    }
                    if let www = current.www {
                        self.newWWW = "\(www)"
                    }
                    
                } else {
                    close = false
                }
            }
            .alert("Удаление", isPresented: $showAlertDelete, actions: {
                SecureField("Пароль", text: $inputPassword)
                Button("Удалить") {
                    if inputPassword == "\(PasswordForEnter.password)" {
                        if let current = currentData {
                            let SQLQuery = """
                            DELETE FROM supplier WHERE supplier_id='\(current.id)';
                            """
                            APIManager.shared.generalUpdate(SQLQuery: SQLQuery) { data, error in
                                guard let _ = data else {
                                    print("== ERROR FROM SupplietDetail func[alert]:", error!)
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.supplierData.refresh()
                                    self.close = false
                                }
                            }
                        } else {
                            self.close = false
                        }
                    }
                }
                Button("Отмена", role: .cancel, action: {})
                
            }, message: {
                Text("Введите пароль, чтобы подтвердить право на удаление.")
            })
            .alert(textInAlert, isPresented: $showAlert) {}
    }
    
    private var MainView: some View {
        VStack {
            Image(systemName: "x.circle")
                .onHover { hovering in
                    self.isHover = hovering
                }
                .onTapGesture {
                    self.close = false
                }
                .foregroundColor(isHover ? .yellow : .white)
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Имя: \(currentData?.name_supplier ?? "не указано")")
                        .font(.system(size: 20))
                    Text("Телефон: \(currentData?.telephone ?? "не указан")")
                        .font(.system(size: 14))
                    if let www = currentData?.www {
                        Text("\(www)")
                            .underline()
                            .foregroundColor(.blue)
                            .font(.system(size: 11))
                    } else {
                        Text("Сайт: не указан")
                            .font(.system(size: 11))
                    }
                }
                Spacer()
            }
            Text("Редактирование:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
                .padding(.vertical)
            MyTextField(textForUser: "Новое имя", text: $newName)
            MyTextField(textForUser: "Новый телефон", text: $newPhone)
            MyTextField(textForUser: "Новое фото", text: $newPhoto)
            MyTextField(textForUser: "Новый сайт", text: $newWWW)
            
            HStack {
                Button {
                    self.showAlertDelete = true
                } label: {
                    Text("Удалить")
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(.black.opacity(0.3))
                        .cornerRadius(20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20).stroke(Color(hexString: "#EC2301"), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
                
                Spacer()
                Button {
                    if newName == "" || newPhone == "" {
                        self.textInAlert = "Имя и телофон должны содержать информацию!"
                        self.showAlert = true
                        return
                    }
                    
                    if let current = currentData {
                        /// Проверка фото на наличие текста внутри.
                        if newPhoto == "" {
                            let sqlString = """
                            UPDATE supplier
                            SET name_supplier='\(newName)',telephone='\(newPhone)',www=\(newWWW == "" ? "NULL" : "'\(newWWW)'"),photo=NULL
                            WHERE supplier_id='\(current.id)';
                            """
                            pullData(SQLQuery: sqlString)
                            
                        } else {
                            /// Проверка фото на корректность ссылки.
                            guard let link = URL(string: newPhoto) else {
                                self.textInAlert = "Ссылка некорректна!"
                                self.showAlert = true
                                return
                            }
                            isPhotoURLValid(url: link) { isValid in
                                if isValid {
                                    let sqlString = """
                                    UPDATE supplier
                                    SET name_supplier='\(newName)',telephone='\(newPhone)',www=\(newWWW == "" ? "NULL" : "'\(newWWW)'"),photo='\(link)'
                                    WHERE supplier_id='\(current.id)';
                                    """
                                    pullData(SQLQuery: sqlString)
                                    
                                } else {
                                    self.textInAlert = "Приложение не может обработать ссылку на эту фоторграфию. Предоставьте другую ссылку."
                                    self.showAlert = true
                                    return
                                }
                            }
                        }
                        
                    } else {
                        close = false
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
                
            }
            
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
                self.textInAlert = "Не получилось обновить данные. Возможно проблема с ссылкой на фото"
                self.showAlert = true
            }
            
        }
    }
}

struct SupplierDetail_Previews: PreviewProvider {
    static var previews: some View {
        SupplierDetail(currentData: .constant(SupplierResult(id: "0", name_supplier: "Жесть какая дорогая штука а не магазин", telephone: "892432948432482", www: URL(string: "https://github.com/mightyK1ngRichard/WoodGrowthCourseWorkSwiftUI"), photo: nil)), close: .constant(false))
    }
}
