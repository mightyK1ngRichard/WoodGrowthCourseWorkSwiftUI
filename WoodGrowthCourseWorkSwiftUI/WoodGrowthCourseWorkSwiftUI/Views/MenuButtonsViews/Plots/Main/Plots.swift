//
//  Plots.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import SwiftUI

struct Plots: View {
    @EnvironmentObject var userData           : UserData
    @ObservedObject var plotData              = plotsCardsViewModel()
    @State private var search                 = ""
    @State private var plusTap                = false
    @State private var isLoaded               = true
    @State private var willNotShowCard        = false
    @State private var isPopoverShown         = false
    @State private var pressedSlider          = false
    @State private var selectedSliderIsFilter = false
    @State private var allFreeTypes           : [(String, String)] = []
    @State private var allFreeEmployees       : [(String, String)] = []
    @State private var searchedPlot           : [PlotResult] = []
    
    
    var body: some View {
        ZStack {
            mainView()
            
            if !isLoaded {
                TurnOffServer()
            }
        }
        .environmentObject(plotData)
    }
    
    private func mainView() -> some View {
        ZStack {
            if !plotData.status {
                TurnOffServer()
                
            } else {
                if !plusTap {
                    cardsPlots()
                    
                } else {
                    AddendumCard(allTypesFree: allFreeTypes, allEmployeesFree: allFreeEmployees, closeScreen: $plusTap, willNotShowCard: $willNotShowCard)
                }
            }
        }
        
    }
    
    private func searchBar() -> some View {
        HStack(spacing: 12) {
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                TextField("Введите имя участка", text: $search, onCommit: {
                    if self.search == "" {
                        self.selectedSliderIsFilter = false
                        self.searchedPlot = []
                        return
                    }
                    self.searchedPlot = self.plotData.plotInfo.filter {
                        $0.name.lowercased().contains(self.search.lowercased()) }
                })
                .onChange(of: search) { newValue in
                    if newValue == "" {
                        self.selectedSliderIsFilter = false
                        self.searchedPlot = []
                    }
                }
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Color.white)
                .font(.system(size: 14, design: .serif))
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.gray
                .opacity(0.7))
            .cornerRadius(10)
            
            Button {
                self.isPopoverShown = true
                
            } label: {
                Image(systemName: isPopoverShown ? "xmark.circle" : "slider.vertical.3")
                    .foregroundColor(Color.black)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
            }
            .buttonStyle(PlainButtonStyle())
            .popover(isPresented: $isPopoverShown, arrowEdge: .bottom) {
                popoverView()
            }
            
            Button {
                if userData.isAdmin {
                    getFreeData()
                }
                
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
                GeometryReader { proxy in
                    ScrollView {
                        Spacer()
                        LazyVGrid(columns: [
                            GridItem(spacing: 70, alignment: .top),
                            GridItem(alignment: .top)
                        ], spacing: 30) {
                            ForEach(searchedPlot.count == 0 ? plotData.plotInfo : searchedPlot) { card in
                                let width = (proxy.size.width - 210) / 2
                                let height = (proxy.size.height) / 2.5
                                PlotCard(plotInfo: card, size: (width, height))
                                    .frame(width: width, height: height)
                                
                            }
                        }
                        .padding(.horizontal, 50)
                        
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
                self.plusTap = true
            }
        }
    }
    
    private func popoverView() -> some View {
        VStack {
            Button {
                self.selectedSliderIsFilter = true
                self.searchedPlot = self.plotData.plotInfo.filter { $0.lastWatering > 20 }
                
            } label: {
                HStack {
                    if selectedSliderIsFilter {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 8, height: 8)
                    }
                    Text("Надо полить")
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(.white)
                .cornerRadius(20)
                .foregroundColor(.black)
            }
            .buttonStyle(.plain)
            
            Button {
                self.selectedSliderIsFilter = false
                self.searchedPlot = []
                
            } label: {
                HStack {
                    if !selectedSliderIsFilter {
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 8, height: 8)
                    }
                    Text("Все участки")
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(.white)
                .cornerRadius(20)
                .foregroundColor(.black)
            }
            .buttonStyle(.plain)
        }
        .frame(width: 120)
        .padding()
    }
    
}

struct Plots_Previews: PreviewProvider {
    static var previews: some View {
        Plots()
    }
}
