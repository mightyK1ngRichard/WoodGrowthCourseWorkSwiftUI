//
//  Employees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Employees: View {
    let window = NSScreen.main?.visibleFrame
    @State var search = ""
    @StateObject var employeesData = employeesCardsViewModel()
    @EnvironmentObject var selectedButtonDetailView: PressedButtonDetailView
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 4)
    
    var body: some View {
        HStack {
            SideBar()
            VStack {
                HStack(spacing: 12) {
                    
                    HStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                        TextField("Поиск", text: $search)
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
                // ScrollView with images...
                GeometryReader { reader in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            // Получает фотки ....
                            ForEach(employeesData.employeesInfo) {card in
                                
                                ScrollViewCard(card: card, reader: reader)
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

struct Employees_Previews: PreviewProvider {
    static var previews: some View {
        Employees()
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {
            
        }
    }
}
