//
//  ScrollViewCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ScrollViewCard: View {
    @EnvironmentObject var selectedButtonDetailView : PressedButtonDetailView
    @EnvironmentObject var allDataEmp               : employeesCardsViewModel
    var card                                        : EmpoyeeResult
    var reader                                      : CGFloat
    @Binding var pressedWateringLog                 : Bool
    @State private var isHovering                   = false
    @State private var isHoveringTrash              = false
    @State private var showAlert                    = false
    @State private var alertText                    = ""
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        VStack {
            photoEmployee()
            infoEmployee()
        }
    }
    
    private func photoEmployee() -> some View {
        ZStack {
            if let photo = card.ava {
                WebImage(url: photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: (reader - 45) / 4, height: 150)
                    .cornerRadius(15)
                
            } else {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: (reader - 45) / 4, height: 150)
                    .cornerRadius(15)
            }
            
            TrashImage()
        }
        .brightness(isHovering ? -0.2 : 0)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) { // добавление плавности анимации
                self.isHovering = hovering
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isHovering) // применение анимации к изменению состояния
        .onTapGesture {
            selectedButtonDetailView.pressed = true
            selectedButtonDetailView.cardInfo = card
            pressedWateringLog = false
        }
    }
    
    private func infoEmployee() -> some View {
        Group {
            Text(card.fullName)
                .font(.title2)
                .bold()
                .lineLimit(1)
            Text("***Должность:*** \(card.post)")
            Text(getCorrectPhone(phoneString: card.phone) ?? "Неверный телефон")
            Text("***Ответсвтвенный за участок:*** \(card.namePlot)")
            Text("***Вид дерева участка:*** \(card.nameType)")
        }
        .foregroundColor(Color.white)
    }
    
    private func TrashImage() -> some View {
        VStack {
            HStack {
                Spacer()
                Circle()
                    .fill(Color.white)
                    .frame(width: 20, height: 20)
                    .overlay {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(isHoveringTrash ? Color(red: 1, green: 0, blue: 0) : .black)
                            .onHover { hovering in
                                self.isHoveringTrash = hovering
                            }
                    }
                    .opacity(isHovering ? (isHoveringTrash ? 1 : 0.7) : 0)
                    .onTapGesture {
                        showAlert = true
                    }
            }
            Spacer()
        }
        .padding(5)
        .alert("Удаление", isPresented: $showAlert, actions: {
            SecureField("Пароль", text: $alertText)
            Button("Удалить", action: {
                if alertText == "430133" {
                    let SQLQuery = "DELETE FROM employer WHERE employer_id=\(card.id);"
                    APIManager.shared.generalUpdate(SQLQuery: SQLQuery) { data, error in
                        guard let _ = data else {
                            print("== ERROR FROM ScrollViewCard", error!)
                            return
                        }
                        self.allDataEmp.refresh()
                        
                        // ... Можно додумать что-то.
                    }
                }
            })
            Button("Отмена", role: .cancel, action: {})
            
        }, message: {
            Text("Введите пароль, чтобы подтвердить право на удаление.")
        })

    }
}

struct ScrollViewCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewCard(card: EmpoyeeResult(id: "0", fullName: "Дмитрий Старший", phone: "891683344342", post: "Boss", ava: URL(string: "https://sun9-54.userapi.com/impg/J_1RV5-5QM1o5tyZtNH9oi0q4xma1K3tJEkynQ/zzDj4CbiK8M.jpg?size=640x640&quality=95&sign=862d94dc0e47df36780ae8523a0d8363&type=album"), namePlot: "V", nameType: "Бамбук"), reader: 1000, pressedWateringLog: .constant(true))
    }
}
