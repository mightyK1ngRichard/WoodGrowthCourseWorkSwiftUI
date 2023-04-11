//
//  EditPlot.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct EditPlot: View {

    var currentData           : PlotResult
    @State var datePlanting   = Date()
    @State var plotName       = ""
    @State var typeTreeOnPlot = ""
    @State var address        = ""
    @State var employee       = ""
    @State var isHover        = false
    @Binding var pressedClose : Bool
    
    init(currentData: PlotResult, pressedClose: Binding<Bool>) {
        // Декодируем дату из строки в Date().
        self.currentData = currentData
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        self._datePlanting = State(initialValue: dateFormatter.date(from: currentData.date) ?? Date())
        
        self._pressedClose = pressedClose
    }
    
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
                MyTextField(textForUser: "Имя участка", text: $plotName)
                MyTextField(textForUser: "Название вида", text: $typeTreeOnPlot)
                MyTextField(textForUser: "Адрес участка", text: $address)
                MyTextField(textForUser: "Ответственный", text: $employee)
                HStack {
                    Text("Дата заземления")
                        .foregroundColor(Color.secondary)
                        .padding(.leading, 4)
                        
                    Spacer()
                    DatePicker("", selection: $datePlanting, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                        
                        .labelsHidden()
                        .frame(width: 150)
                }


                Button(action: {
                    
                    
                }, label: {
                    Text("Save")
                })
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                       
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
        EditPlot(currentData: PlotResult(id: "0", name: "F", date: "2023-02-14T21:00:00.000Z", address: "Ул. Далеко что жесть", employee: "Вова Степанов", emp_photo: nil, type_tree: "Берёза", fertilizerName: "Удобрение 1", countTrees: "23"), pressedClose: .constant(false))
    }
}
