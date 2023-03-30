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
    var reader                                      : GeometryProxy // reader надо комментить при вёрстке
    @State private var isHovering                   = false
    
    var body: some View {
        VStack {
            Group {
                if let photo = card.ava {
                    WebImage(url: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: (reader.frame(in: .global).width - 45) / 4, height: 150)
                        .cornerRadius(15)
                    
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: (reader.frame(in: .global).width - 45) / 4, height: 150)
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
            }
            
            Group {
                Text(card.fullName)
                    .font(.title2)
                    .bold()
                Text("***Должность:*** \(card.post)")
                Text(getCorrectPhone(phoneString: card.phone) ?? "Неверный телефон")
                Text("***Ответсвтвенный за участок:*** \(card.namePlot)")
                Text("***Вид дерева участка:*** \(card.nameType)")
            }
            .foregroundColor(Color.white)
        }
    }
}

//struct ScrollViewCard_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollViewCard(card: EmpoyeeResult(id: "0", fullName: "Лол лол", phone: "89163442455", post: "Boss", ava: nil), reader: nil)
//    }
//}
