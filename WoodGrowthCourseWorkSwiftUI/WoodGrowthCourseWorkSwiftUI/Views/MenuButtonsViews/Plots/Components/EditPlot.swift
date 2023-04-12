//
//  EditPlot.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct EditPlot: View {

    var currentData                   : PlotResult
    @State private var datePlanting   = Date()
    @State private var plotName       = ""
    @State private var typeTreeOnPlot = ""
    @State private var address        = ""
    @State private var employee       = ""
    @State private var isHover        = false
    @Binding var pressedClose         : Bool
    var allEmployees         : [AllEmpoyeesResult]
    
    init(currentData: PlotResult, pressedClose: Binding<Bool>, allEmployees: [AllEmpoyeesResult]) {
        // Декодируем дату из строки в Date().
        self.currentData = currentData
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        self._datePlanting = State(initialValue: dateFormatter.date(from: currentData.date) ?? Date())
        
        self._employee = State(initialValue: currentData.employerID)
        self._pressedClose = pressedClose
        self.allEmployees = allEmployees
    }
    
    var body: some View {
    
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
            HStack {
                Text("Ответственный")
                    .foregroundColor(Color.secondary)
                    .padding(.leading, 4.1)
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Picker(selection: $employee, label: Text("")) {
                    ForEach(allEmployees) { person in
                        Text(person.fullName)
                    }
                }
                .labelsHidden()
                .frame(width: 150)
            }
            
            HStack {
                Text("Дата заземления")
                    .foregroundColor(Color.secondary)
                    .padding(.leading, 4)
                    
                Spacer()
                Image(systemName: "calendar.badge.clock")
                    .resizable()
                    .frame(width: 20, height: 20)
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
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(getGradient().opacity(0.7), lineWidth: 3)
        }
        .frame(width: 500, height: 330)
    }
}

struct EditPlot_Previews: PreviewProvider {
    static var previews: some View {
        EditPlot(currentData: PlotResult(id: "0", name: "F", date: "2023-02-14T21:00:00.000Z", address: "Ул. Далеко что жесть", employee: "Вова Степанов", emp_photo: nil, type_tree: "Берёза", fertilizerName: "Удобрение 1", countTrees: "23", employerID: "0"), pressedClose: .constant(false), allEmployees: [AllEmpoyeesResult(id: "0", fullName: "Стэс Стэсович")])
    }
}
