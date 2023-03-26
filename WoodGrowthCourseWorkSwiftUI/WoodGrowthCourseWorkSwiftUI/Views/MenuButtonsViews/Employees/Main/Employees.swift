//
//  Employees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Employees: View {
    var columns                         = Array(repeating: GridItem(.flexible(), spacing: 15), count: 4)
    @State private var search           = ""
    @State private var output           = ""
    @State private var peopleFromSearch = [EmpoyeeResult]()
    @StateObject var employeesData      = employeesCardsViewModel()
    
    var body: some View {
        HStack {
            // Если ошибка на сервере.
            if !employeesData.statusParse {
                TurnOffServer()
                
            } else {
                VStack {
                    HStack(spacing: 12) {
                        HStack(spacing: 15) {
                            Image(systemName: "magnifyingglass")
                            TextField("Введите имя", text: $search) {
                                self.output = self.search
                                self.peopleFromSearch = self.employeesData.employeesInfo.filter { $0.fullName.lowercased().contains(self.output) }
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
                    
                    if output == "" {
                        // ScrollView with images.
                        GeometryReader { reader in
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 15) {
                                    ForEach(employeesData.employeesInfo) {card in
                                        ScrollViewCard(card: card, reader: reader)
                                    }
                                }
                            }
                        }
                        
                    } else {
                        GeometryReader { reader in
                            ScrollView {
                                LazyVGrid(columns: columns, spacing: 15) {
                                    ForEach(peopleFromSearch) {card in
                                        ScrollViewCard(card: card, reader: reader)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }

    }
    
}
