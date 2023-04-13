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
    var card                                        : EmpoyeeResult
    var reader                                      : CGFloat
    @Binding var pressedWateringLog                 : Bool
    @State private var isHovering                   = false
    
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
        Group {
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
}

struct ScrollViewCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewCard(card: EmpoyeeResult(id: "0", fullName: "Дмитрий Старший", phone: "891683344342", post: "Boss", ava: URL(string: "https://sun9-54.userapi.com/impg/J_1RV5-5QM1o5tyZtNH9oi0q4xma1K3tJEkynQ/zzDj4CbiK8M.jpg?size=640x640&quality=95&sign=862d94dc0e47df36780ae8523a0d8363&type=album"), namePlot: "V", nameType: "Бамбук"), reader: 1000, pressedWateringLog: .constant(true))
    }
}
