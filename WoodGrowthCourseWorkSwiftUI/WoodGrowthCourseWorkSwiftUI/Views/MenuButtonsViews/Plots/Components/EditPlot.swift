//
//  EditPlot.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct EditPlot: View {
    var currentData                   : PlotResult
    var size                          : (width: CGFloat, height: CGFloat)
    @State private var datePlanting   = Date()
    @State private var plotName       = ""
    @State private var typeTreeOnPlot = ""
    @State private var address        = ""
    @State private var employee       = ""
    @State private var isHover        = false
    @Binding var pressedClose         : Bool
    var allTypesFree                  : [(String, String)]
    var allEmployeesFree              : [(String, String)]
    @EnvironmentObject var plotsData  : plotsCardsViewModel
    
    init(currentData: PlotResult, size: (width: CGFloat, height: CGFloat), pressedClose: Binding<Bool>, allTypesFree: [(String, String)], allEmployeesFree: [(String, String)]) {
        // Декодируем дату из строки в Date().
        self.size = size
        self.currentData = currentData
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let newDate = dateFormatter.date(from: currentData.date)!
        self._datePlanting = State(initialValue: newDate)
        self._pressedClose = pressedClose
        self._employee = State(initialValue: currentData.employerID)
        self._typeTreeOnPlot = State(initialValue: "\(currentData.typeTreeID)")
        self.allTypesFree = allTypesFree
        self.allEmployeesFree = allEmployeesFree
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
            MyTextField(textForUser: "Адрес участка", text: $address)
            
            myPickers()
            
            Button(action: {
                let commands = [
                    ("name_plot", plotName),
                    ("date_planting", correctDateWithTime(datePlanting)),
                    ("type_tree_id", typeTreeOnPlot),
                    ("address", address),
                    ("employer_id", employee)
                ].filter { $0.1 != "" }
                
                // Если ничего не поменяли, выходим.
                if commands.count == 0 {
                    pressedClose = false
                    return
                }
                
                let changedInfo = commands.map { "\($0.0)='\($0.1)'" }.joined(separator: ", ")
                let sqlString = "UPDATE plot SET \(changedInfo) WHERE plot_id=\(currentData.id);"
                
                APIManager.shared.generalUpdate(SQLQuery: sqlString) { data, error in
                    guard let _ = data else {
                        print("== ERROR FROM EditPlot [Button]<Save>", error!)
                        // .... Что-то выводить при ошибке
                        return
                    }
//                    print("Обновление выполнено успешно\n", data)
                    DispatchQueue.main.async  {
                        plotsData.refresh()
                        pressedClose = false
                    }
                    
                }
                                
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
        .frame(width: size.width, height: size.height)
        .padding()
    }
    
    private func myPickers() -> some View {
        VStack {
            HStack {
                Text("Вид дерева")
                    .foregroundColor(Color.secondary)
                    .padding(.leading, 4.1)
                Spacer()
                Image(systemName: "tree.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Picker(selection: $typeTreeOnPlot, label: Text("")) {
                    ForEach(allTypesFree, id: \.0) { type in
                        Text(type.1)
                    }
                }
                .labelsHidden()
                .frame(width: 150)
            }
            
            HStack {
                Text("Ответственный")
                    .foregroundColor(Color.secondary)
                    .padding(.leading, 4.1)
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Picker(selection: $employee, label: Text("")) {
                    ForEach(allEmployeesFree, id: \.0) { person in
                        Text(person.1)
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
        }
    }
}

struct EditPlot_Previews: PreviewProvider {
    static var previews: some View {
        EditPlot(currentData: PlotResult(id: "0", name: "F", date: "2017-02-14T21:00:00.000Z", address: "Ул. Далеко что жесть", employee: "Вова Степанов", emp_photo: nil, type_tree: "Берёза", fertilizerName: "Удобрение 1", countTrees: "23", employerID: "0", typeTreeID: 0, typephoto: URL(string: "https://phonoteka.org/uploads/posts/2021-05/1621391291_26-phonoteka_org-p-luntik-fon-27.jpg")!), size: (width: CGFloat(500), height: CGFloat(330)), pressedClose: .constant(false), allTypesFree: [("0", "Лол")], allEmployeesFree: [("0", "Кек")])
    }
}
