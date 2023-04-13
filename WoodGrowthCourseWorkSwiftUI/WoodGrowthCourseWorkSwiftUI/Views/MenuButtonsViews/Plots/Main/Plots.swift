//
//  Plots.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import SwiftUI

struct Plots: View {
    var columns                         = Array(repeating: GridItem(.flexible()), count: 2)
    @State private var search           = ""
    @State private var output           = ""
    @State private var plusTap          = false
    @State private var isLoaded         = false
    @State private var showAlert        = false
    @State private var willNotShowCard  = false
    @State private var allFreeTypes     : [(String, String)] = []
    @State private var allFreeEmployees : [(String, String)] = []
    @ObservedObject var plotData        = plotsCardsViewModel()
    
    var body: some View {
        ZStack {
            mainView()
                .onAppear() {
                    getFreeData()
                }

            if !isLoaded {
                TurnOffServer()
            }
        }
        .environmentObject(plotData)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Ошибка"), message: Text("Заполните все поля!"), dismissButton: .default(Text("OK")))
        }
        // TODO: Подумать, как оформить несколько alert.
        /*
         .alert(isPresented: $willNotShowCard) {
             Alert(
                 title: Text("Запрет"),
                 message: Text("Вы не можете создать участок, у вас нету свободных работников или видов деревьев."),
                 dismissButton: .default(Text("OK"), action: {
                     plusTap = false
                 })
             )
         }
         */
    }
    
    private func mainView() -> some View {
        ZStack {
            if !plotData.status {
                TurnOffServer()
                
            } else {
                if !plusTap {
                    cardsPlots()
                    
                } else {
                    AddendumCard(allTypesFree: allFreeTypes, allEmployeesFree: allFreeEmployees, showAlert: $showAlert, closeScreen: $plusTap, willNotShowCard: $willNotShowCard)
                }
            }
        }
        
    }
    
    private func searchBar() -> some View {
        HStack(spacing: 12) {
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                TextField("Введите имя", text: $search) {
                    self.output = self.search
                    //                                self.peopleFromSearch = self.employeesData.employeesInfo.filter { $0.fullName.lowercased().contains(self.output) }
                }
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Color.black)
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.gray
                .opacity(0.7))
            .cornerRadius(10)
            
            Button {
                // TODO: Сделать
                
            } label: {
                Image(systemName: "slider.vertical.3")
                    .foregroundColor(Color.black)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                plusTap = true
                
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(.vertical)
        .padding(.horizontal, 60)
    }
    
    private func cardsPlots() -> some View {
        GeometryReader { reader in
            VStack {
                searchBar()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(plotData.plotInfo) {card in
                            PlotCard(plotInfo: card)
                                .padding()
                        }
                    }
                }
                
            }
        }
    }
    
    private func getFreeData() {
        self.isLoaded = false
        APIManager.shared.getAllEmpoyeesAndTypes { data, error in
            guard let data = data else {
                print("== ERROR FROM EditPlot:", error!)
                return
            }
            
            var tempTypes: [(String, String)] = []
            var tempEmployees: [(String, String)] = []

            for el in data.rows {
                if el.type_id == nil {
                    guard let t1 = el.employer_id, let t2 = el.full_name else {
                        print("== ERROR2 PlotCard. Невозможная ситуация, nil там, где его не может быть. Мб неверно заполнена БД. А именно для работника = \(el.employer_id ?? "Пусто"), или вида дерева \(String(describing: el.type_id))")
                        return }
                    
                    tempEmployees.append((t1, t2))
                }
                
                else if el.employer_id == nil {
                    guard let t1 = el.type_id, let t2 = el.name_type else {
                        print("== ERROR2 PlotCard. Невозможная ситуация, nil там, где его не может быть. Мб неверно заполнена БД. А именно для работника = \(el.employer_id ?? "Пусто"), или вида дерева \(String(describing: el.type_id))")
                        return
                    }
                    
                    tempTypes.append((t1, t2))
                }
            }
            
            DispatchQueue.main.async {
                self.allFreeEmployees = tempEmployees
                self.allFreeTypes = tempTypes
                self.isLoaded = true
            }
        }
    }
    
}

struct Plots_Previews: PreviewProvider {
    static var previews: some View {
        Plots()
    }
}
