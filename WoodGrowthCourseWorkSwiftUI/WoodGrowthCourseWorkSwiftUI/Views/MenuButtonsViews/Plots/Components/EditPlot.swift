//
//  EditPlot.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct EditPlot: View {
    var currentData                    : PlotResult
    var size                           : (width: CGFloat, height: CGFloat)
    @State private var datePlanting    = Date()
    @State private var newDatePlanting = Date()
    @State private var plotName        = ""
    @State private var typeTreeOnPlot  = ""
    @State private var address         = ""
    @State private var employee        = ""
    @State private var isHover         = false
    @State private var pressedWatering = false
    @Binding var pressedClose          : Bool
    var allTypesFree                   : [(String, String)]
    var allEmployeesFree               : [(String, String)]
    @EnvironmentObject var plotsData   : plotsCardsViewModel
    
    
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
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(.black.opacity(0.8))
            
            if !pressedWatering {
                editView
                
            } else {
                AddWateringScreen
            }
            
        }
        .frame(width: size.width, height: size.height)
        .padding()
    }
    
    private var editView: some View {
        VStack {
            closeViewButton()
            
            Spacer()
            MyTextFieldBlack(textForUser: "Имя участка", text: $plotName)
            MyTextFieldBlack(textForUser: "Адрес участка", text: $address)
            
            myPickers()
            
            Buttons()
            Spacer()
        }
        .padding(.horizontal)
        .background(getTabBackground().opacity(0.3))
        .cornerRadius(15)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(hexString: "#EC2301"), lineWidth: 1)
        }
    }
    
    private var AddWateringScreen: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    self.pressedWatering = false
                    
                } label: {
                    Image(systemName: "x.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(isHover ? .red : .white)
                        .padding(.trailing, 0)
                        .padding(.top, 10)
                        .onHover { hovering in
                            isHover = hovering
                        }
                        .offset(x: 7)
                }
                .buttonStyle(.plain)
            }
            Spacer()
            
            DatePicker("Дата поливки", selection: $newDatePlanting, in: ...Date())
            
            Spacer()
            Button {
                addWatering()
                
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
            .padding(.bottom)
        }
        .padding(.horizontal)
        .background(getTabBackground().opacity(0.3))
        .cornerRadius(15)
        .overlay {
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(hexString: "#EC2301"), lineWidth: 1)
        }
    }
    
    private func closeViewButton() -> some View {
        HStack {
            Spacer()
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(isHover ? .yellow : .white)
                .padding(.trailing, 0)
                .padding(.top, 10)
                .onTapGesture {
                    self.pressedClose = false
                }
                .onHover { hovering in
                    isHover = hovering
                }
                .offset(x: 7)
        }
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
    
    private func Buttons() -> some View {
        HStack {
            Button {
                self.pressedWatering = true
                
            } label: {
                Text("Новая поливка")
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
            
            Button(action: {
                updatePlot()
                
            }, label: {
                Text("Сохранить")
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.3))
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20).stroke(Color(hexString: "#EC2301"), lineWidth: 1)
                    }
            })
            .buttonStyle(.plain)
        }
        .offset(y: 15)
    }
    
    private func updatePlot() {
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
                
                return
            }
            
            DispatchQueue.main.async  {
                plotsData.refresh()
                pressedClose = false
            }
            
        }
    }
    
    private func addWatering() {
        let SQLQuery = "INSERT INTO watering (date_watering, plot_id) VALUES ('\(correctDateWithTime(newDatePlanting))', '\(currentData.id)');"
        
        APIManager.shared.updateWithSlash(SQLQuery: SQLQuery) { resp, error in
            guard let _ = resp else {
                DispatchQueue.main.async {
                    self.plotsData.refresh()
                    self.pressedWatering = false
                }
                return
            }
            print("==> ERROR FROM EditPlot func[addWatering]")
        }
    }
}

struct EditPlot_Previews: PreviewProvider {
    static var previews: some View {
        EditPlot(currentData: PlotResult(id: "0", name: "F", date: "2017-02-14T21:00:00.000Z", address: "Ул. Далеко что жесть", employee: "Вова Степанов", emp_photo: nil, type_tree: "Берёза", fertilizerName: "Удобрение 1", countTrees: "23", employerID: "0", typeTreeID: 0, typephoto: URL(string: "https://phonoteka.org/uploads/posts/2021-05/1621391291_26-phonoteka_org-p-luntik-fon-27.jpg")!, lastWatering: 23), size: (width: CGFloat(500), height: CGFloat(330)), pressedClose: .constant(false), allTypesFree: [("0", "Лол")], allEmployeesFree: [("0", "Кек")])
    }
}
