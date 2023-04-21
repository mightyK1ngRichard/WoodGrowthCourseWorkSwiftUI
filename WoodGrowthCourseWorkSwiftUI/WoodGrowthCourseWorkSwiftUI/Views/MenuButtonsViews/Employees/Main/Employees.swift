//
//  Employees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Employees: View {
    
    var columns                            = Array(repeating: GridItem(.flexible(), spacing: 15), count: 4)
    @State private var search              = ""
    @State private var output              = ""
    @State private var peopleFromSearch    = [EmpoyeeResult]()
    @State private var pressedPlus         = false
    @State private var pressedWateringLog  = false
    @ObservedObject var pressedCardInfo    = PressedButtonDetailView()
    @ObservedObject var employeesData      = employeesCardsViewModel()
    
    
    var body: some View {
        mainView()
            .environmentObject(pressedCardInfo)
            .environmentObject(employeesData)
    }
    
    private func mainView() -> some View {
        
        VStack {
            if pressedCardInfo.pressed {
                HStack {
                    infoView()
                    
                    VStack {
                        DetailCard(pressedWateringLog: $pressedWateringLog, currentPersonInfo: pressedCardInfo.cardInfo!)
                        Spacer()
                    }
                    .padding(.top, 55)
                    .background(getGradient())
                }
                
            } else {
                infoView()
            }
        }
    }
    
    private func infoView() -> some View {
        ZStack {
            // Меню редактирования.
            if pressedPlus {
                AddEmployee(closeScreen: $pressedPlus)
            
            } else {
                // Карточки работников.
                VStack {
                    searchBar()
                    cardEmployees()
                }
                .padding()
            }
            
            // Анимация загрузки.
            if !employeesData.statusParse {
                TurnOffServer()
            }
            
        }
    }
    
    private func cardEmployees() -> some View {
        GeometryReader { reader in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    if output == "" {
                        ForEach(employeesData.employeesInfo) {card in
                            ScrollViewCard(card: card, reader: reader.frame(in: .global).width, pressedWateringLog: $pressedWateringLog)
                        }
                        
                    } else {
                        ForEach(peopleFromSearch) {card in
                            ScrollViewCard(card: card, reader: reader.frame(in: .global).width, pressedWateringLog: $pressedWateringLog)
                        }
                    }
                    
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
                    self.peopleFromSearch = self.employeesData.employeesInfo.filter { $0.fullName.lowercased().contains(self.output.lowercased()) }
                }
                .onChange(of: search) { newValue in
                    if newValue == "" {
                        self.peopleFromSearch = []
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
                pressedPlus = true
                
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
}


struct Employees_Previews: PreviewProvider {
    static var previews: some View {
        Employees()
    }
}
