//
//  AddendumCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 13.04.2023.
//

import SwiftUI

struct AddendumCard: View {
    var allTypesFree                   : [(String, String)]
    var allEmployeesFree               : [(String, String)]
    @State private var newNamePlot     = ""
    @State private var newTypeTree     = ""
    @State private var newAddress      = ""
    @State private var newEmployee     = ""
    @State private var newDatePlanting = Date()
    @State private var isHover         = false
    @Binding var showAlert             : Bool
    @Binding var closeScreen           : Bool
    @Binding var willNotShowCard       : Bool
    @EnvironmentObject var plotsData   : plotsCardsViewModel
    
    init(allTypesFree: [(String, String)], allEmployeesFree: [(String, String)], showAlert: Binding<Bool>, closeScreen: Binding<Bool>, willNotShowCard: Binding<Bool>) {
        
        self.allTypesFree = allTypesFree
        self.allEmployeesFree = allEmployeesFree
        self._closeScreen = closeScreen
        self._showAlert = showAlert
        self._willNotShowCard = willNotShowCard
        
        // Если нету свободных типов или работников, запрет создавать.
        if allEmployeesFree.count != 0 && allTypesFree.count != 0{
            self._newEmployee = State(initialValue: allEmployeesFree[0].0)
            self._newTypeTree = State(initialValue: allTypesFree[0].0)
        } else {
            self.willNotShowCard = true
        }
    }
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        VStack {
            Text("Добавления участка.")
                .font(.system(size: 40))
                .bold()
            
            HStack {
                Spacer()
                VStack {
                    closeCard()
                    inputDataView()
                }
                .padding()
                .frame(width: 500, height: 400)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(getGradient(), lineWidth: 3)
                }
                
                Spacer()
            }
        }
    }
    
    private func closeCard() -> some View {
        HStack {
            Spacer()
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(isHover ? .red : .white)
                .padding(.trailing, 0)
                .padding(.top, 10)
                .onTapGesture {
                    closeScreen = false
                }
                .onHover { hovering in
                    isHover = hovering
                }
                .offset(y: -77)
        }
    }
    
    private func willNotShowView() -> some View {
        VStack {
            HStack {
                Spacer()
                
                Text("Вы не можете создать участок, у вас нету свободных работников или видов деревьев.")
                    .font(.title)
                    .foregroundColor(.red)
                
                Spacer()
            }
        }
    }
    
    private func inputDataView() -> some View {
        VStack {
            MyTextField(textForUser: "Название участка", text: $newNamePlot)
            MyTextField(textForUser: "Адрес участка", text: $newAddress)
        
            myPickers()
            
            Button("Save") {
                if newAddress == "" || newNamePlot == "" {
                    self.showAlert = true
                    return
                }
               
                let sqlString = """
                INSERT
                INTO plot (name_plot, date_planting, type_tree_id, address, employer_id)
                VALUES ('\(newNamePlot)', '\(correctDateWithTime(newDatePlanting))', '\(newTypeTree)', '\(newAddress)', '\(newEmployee)');
                """
                APIRequest(sqlString)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top)
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
                Picker(selection: $newTypeTree, label: Text("")) {
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
                Picker(selection: $newEmployee, label: Text("")) {
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
                DatePicker("", selection: $newDatePlanting, in: ...Date(), displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                    .frame(width: 150)
            }
        }
    }
        
    private func APIRequest(_ sqlString: String) {
        APIManager.shared.generalUpdate(SQLQuery: sqlString) { data, error in
            guard let _ = data else {
                print("== ERROR FROM EditPlot [Button]<Save>", error!)
                // .... Что-то выводить при ошибке
                return
            }
//                    print("Обновление выполнено успешно\n", data)
            DispatchQueue.main.async  {
                
                closeScreen = false
                plotsData.refresh()
            }
            
        }
    }
}

struct AddendumCard_Previews: PreviewProvider {
    static var previews: some View {
        AddendumCard(allTypesFree: [("0", "Привет")], allEmployeesFree: [("0", "Пока")], showAlert: .constant(false), closeScreen: .constant(false), willNotShowCard: .constant(false))
    }
}
