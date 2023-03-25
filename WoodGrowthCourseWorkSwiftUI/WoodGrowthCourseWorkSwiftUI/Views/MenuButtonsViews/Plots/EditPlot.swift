//
//  EditPlot.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct EditPlot: View {
    @State var datePlanting   = ""
    @State var plotName       = ""
    @State var typeTreeOnPlot = ""
    @State var address        = ""
    @State var employee       = ""
    @State var isHover        = false
    @Binding var pressedClose : Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isHover ? .red : .white)
                        .padding(.trailing, 0)
                        .padding(.top, 10)
                        .onTapGesture {
                            pressedClose = false
                        }
                        .onHover { hovering in
                            isHover = hovering
                        }

                }
                Spacer()
                MyTextField(textForUser: "Новое имя участка", text: $plotName)
                MyTextField(textForUser: "Новая дата", text: $datePlanting)
                MyTextField(textForUser: "Новый вид", text: $typeTreeOnPlot)
                MyTextField(textForUser: "Новый адресс", text: $address)
                MyTextField(textForUser: "Новый сотрудник", text: $employee)
                Spacer()
            }
            .padding(.horizontal)
        }
        .frame(width: 500, height: 332)
        .cornerRadius(10)
    }
}

struct EditPlot_Previews: PreviewProvider {
    static var previews: some View {
        EditPlot(pressedClose: .constant(false))
    }
}
