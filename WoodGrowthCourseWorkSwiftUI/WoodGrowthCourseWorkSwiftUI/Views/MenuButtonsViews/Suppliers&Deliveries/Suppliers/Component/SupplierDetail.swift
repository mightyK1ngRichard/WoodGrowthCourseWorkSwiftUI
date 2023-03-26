//
//  SupplierDetail.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import SwiftUI

struct SupplierDetail: View {
    @Binding var currentData    : SupplierResult?
    @Binding var close  : Bool
    @State private var newName  = ""
    @State private var newPhone = ""
    @State private var newWWW   = ""
    @State private var isHover  = false
    
    var body: some View {
        VStack {
            Image(systemName: "x.circle")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(isHover ? .red : .white)
                .onHover { hovering in
                    isHover = hovering
                }
                .onTapGesture {
                    close = false
                }
            
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
            Text("Измените, что надо:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
                .padding(.vertical)
            MyTextField(textForUser: "Новое имя", text: $newName)
            MyTextField(textForUser: "Новый телефон", text: $newPhone)
            MyTextField(textForUser: "Новый сайт", text: $newWWW)
        }
        .padding()
        .background(.black)
        .frame(width: 500)
        .cornerRadius(20)
        .shadow(color: .red, radius: 20)
    }
}

struct SupplierDetail_Previews: PreviewProvider {
    static var previews: some View {
        SupplierDetail(currentData: .constant(SupplierResult(id: "0", name_supplier: "Жесть какая дорогая штука а не магазин", telephone: "892432948432482", www: URL(string: "https://github.com/mightyK1ngRichard/WoodGrowthCourseWorkSwiftUI"), photo: nil)), close: .constant(false))
    }
}
