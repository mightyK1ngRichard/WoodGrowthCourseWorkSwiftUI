//
//  FertilizerEdit.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct FertilizerEdit: View {
    @State private var fertilizerName  = ""
    @State private var fertilizerPrice = ""
    @State private var fertilizerMass  = ""
    @State private var typeTree        = ""
    @State private var isHover         = false
    @Binding var close                 : Bool
    
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
            
            
            Spacer()
            MyTextField(textForUser: "Новое название корма", text: $fertilizerName)
            MyTextField(textForUser: "Новая цена", text: $fertilizerPrice)
            MyTextField(textForUser: "Новая масса", text: $fertilizerMass)
            MyTextField(textForUser: "Новый вид дерева", text: $typeTree)
            Button(action: {
                close = false
                // TODO: ?
                print(fertilizerName, fertilizerPrice, fertilizerMass, typeTree, separator: "\n")
                
                
            }) {
                Text("Save")
                    .padding()
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            Spacer()
        }
        .padding()
        .frame(width: 400, height: 300)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
    }
}

struct FertilizerEdit_Previews: PreviewProvider {
    static var previews: some View {
        FertilizerEdit(close: .constant(false))
    }
}
