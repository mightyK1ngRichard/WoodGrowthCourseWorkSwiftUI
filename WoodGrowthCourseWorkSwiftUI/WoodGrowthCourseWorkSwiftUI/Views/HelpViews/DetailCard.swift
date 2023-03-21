//
//  DetailCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 21.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailCard: View {
    @EnvironmentObject var pressedClose: PressedButtonDetailView
    @State private var isHovering = false
    @State private var isHoveringPhoto = false
    
    var currentPersonInfo: EmpoyeeResult?
    var body: some View {
        VStack {
            Image(systemName: "xmark.circle")
            .offset(x: 90)
            .colorMultiply(isHovering ? .yellow : .black)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.isHovering = hovering
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isHovering)
            .onTapGesture {
                pressedClose.pressed = false
            }
            
            Group {
                if let image = currentPersonInfo?.ava {
                    WebImage(url: image)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding(.top, 0)
                        .clipShape(Circle())
                    
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .padding(.top, 0)
                }
            }
            .brightness(isHoveringPhoto ? -0.2 : 0)
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.isHoveringPhoto = hovering
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isHoveringPhoto)
            .onTapGesture {
                pressedClose.pressed = false
            }
            
            Text("\(currentPersonInfo?.fullName ?? "Имя не найдено")")
                .padding(0)
                .font(.title)
                .bold()
            Text("\(currentPersonInfo?.post ?? "Должность не указана")")
            if let phone = currentPersonInfo?.phone {
                Text((getCorrectPhone(phoneString: phone) ?? "Телефон некорректный"))
            } else {
                Text("Телефон отсутствует")
            }
        }
        .frame(width: 221)
        .background(Color.clear)
    }
}

struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(currentPersonInfo: nil)
    }
}
