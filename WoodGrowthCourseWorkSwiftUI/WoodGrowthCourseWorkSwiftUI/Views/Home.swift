//
//  Home.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    let window = NSScreen.main?.visibleFrame
    @State var search = ""
    @StateObject var employeesData = employeesCardsViewModel()
    
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 4)
    
    var body: some View {
        HStack {
            SideBar()
            VStack {
                
                HStack(spacing: 12) {
                    
                    // search bar
                    
                    HStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                        TextField("Поиск", text: $search)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.black)
                        
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
                            .foregroundColor(.black)
                            .padding(10)
                            .background(.white)
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
                                if let photo = card.ava {
                                    WebImage(url: photo)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (reader.frame(in: .global).width - 45) / 4, height: 150)
                                        .cornerRadius(15)
                                } else {
                                    WebImage(url: URL(string: "https://sun1-54.userapi.com/impg/J_1RV5-5QM1o5tyZtNH9oi0q4xma1K3tJEkynQ/zzDj4CbiK8M.jpg?size=640x640&quality=95&sign=862d94dc0e47df36780ae8523a0d8363&type=album")!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (reader.frame(in: .global).width - 45) / 4, height: 150)
                                        .cornerRadius(15)
                                    // TODO: ставим фото по умолчанию
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
        //        .frame(width: window!.width / 1.5, height: window!.height - 40)
        .frame(minWidth: window!.width / 1.5, minHeight: window!.height - 50,maxHeight: window!.height - 50)
        .background(Color.white.opacity(0.6))
        .background(BlurWindow())
        .ignoresSafeArea(.all, edges: .all)
        
    }
}

struct SideBar: View {
    @State var selected = "Home"
    @Namespace var animation
    
    var body: some View {
        HStack(spacing: 0) {
            
            VStack(spacing: 22) {
                
                Group {
                    HStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                        Text("Wood Business")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 35)
                    .padding(.leading, 10)
                    // Tab Button
                    TabButton(image: "house.fill", title: "Home", animation: animation, selected: $selected)
                    
                    TabButton(image: "tree.circle", title: "Деревья", animation: animation, selected: $selected)
                    
                    TabButton(image: "person.fill", title: "Работники", animation: animation, selected: $selected)
                    
                    TabButton(image: "person.fill", title: "Деревья", animation: animation, selected: $selected)
                    
                    TabButton(image: "person.fill", title: "Участки", animation: animation, selected: $selected)
                }
                
                Spacer(minLength: 0)
                
                VStack(spacing: 5) {
                    //                    Image("money")
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fit)
                    
                    Button {
                        // TODO: придумать
                        
                    } label: {
                        Text("Прочее")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                
                Spacer(minLength: 0)
            }
            
            Divider()
                .offset(x: -2)
        }
        .frame(width: 220)
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
