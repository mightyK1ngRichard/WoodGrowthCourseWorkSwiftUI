//
//  Plots.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import SwiftUI

struct Plots: View {
    var columns                  = Array(repeating: GridItem(.flexible()), count: 2)
    @State private var search    = ""
    @State private var output    = ""
    @ObservedObject var plotData = plotsCardsViewModel()
    
    var body: some View {
        if !plotData.status {
            TurnOffServer()
            
        } else {
            GeometryReader { reader in
                VStack {
                    searchBar()
                    
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(plotData.plotInfo) {card in
                                PlotCard(plotInfo: card)
    //                                .frame(width: reader.size.width / 2 - 40, height: 330)
                                    .padding()
                            }
                        }
                    }
                }
            }
            .environmentObject(plotData)
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
                // TODO: Сделать
                
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
}

struct Plots_Previews: PreviewProvider {
    static var previews: some View {
        Plots()
    }
}
