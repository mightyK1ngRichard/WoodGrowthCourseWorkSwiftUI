//
//  DetailCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 21.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailCard: View {
    @EnvironmentObject var pressedClose   : PressedButtonDetailView
    @State var pressedEdit                = false
    @State private var isHovering         = false
    @State private var isHoveringPhoto    = false
    @State private var isHoveringWater    = false
    @State private var pressedWateringLog = false
    @State private var newName            = ""
    @State private var newSurname         = ""
    @State private var newPost            = ""
    @State private var newPhone           = ""
    var currentPersonInfo                 : EmpoyeeResult
    @State private var wateringLog        : [RowsWateringEmployee] = []
    
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "square.and.pencil")
                    .offset(x: 96, y: 255)
                    .colorMultiply(isHovering ? .yellow : .black)
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isHovering = hovering
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: isHovering)
                    .onTapGesture {
                        pressedEdit.toggle()
                    }
                
                Image(systemName: "eye.fill")
                    .offset(x: -96, y: 255)
                    .colorMultiply(isHoveringWater ? .blue : .black)
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isHoveringWater = hovering
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: isHovering)
                    .onTapGesture {
                        pressedWateringLog.toggle()
                        APIManager.shared.getWateringUser(userID: currentPersonInfo.id) { data, error in
                            guard let data = data else {
                                print("== ERROR data is empty")
                                return
                            }
                            wateringLog = data.rows
                        }
                    }
            }
            Group {
                if let image = currentPersonInfo.ava {
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
            
            Text(currentPersonInfo.fullName)
                .padding(0)
                .font(.title)
                .bold()
            Text(currentPersonInfo.post)
            if let phone = currentPersonInfo.phone {
                Text((getCorrectPhone(phoneString: phone) ?? "Телефон некорректный"))
            } else {
                Text("Телефон отсутствует")
            }
            if pressedWateringLog {
                VStack {
                    Text("Даты поливки:")
                        .bold()
                    ForEach(wateringLog, id: \.self.date_) {
                        Text(correctDate(dateString: $0.date_))
                            .padding(.horizontal)
                    }
                }.padding(.top, 10)
            }
            
            // pressedEdit
            if pressedEdit {
                VStack {
                    Group {
                        MyTextField(textForUser: "Введите новое имя", text: $newName)
                        MyTextField(textForUser: "Введите новую фамилию", text: $newSurname)
                        MyTextField(textForUser: "Введите новую должность", text: $newPost)
                        MyTextField(textForUser: "Введите новый телефон", text: $newPhone)
                    }
                    
                    Button {
                        // TODO: Запрос обновы БД.
                        self.pressedEdit = false
                        print(newName)
                        print(newSurname)
                        print(newPost)
                        print(newPhone)
                        
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Сохранить")
                        }
                    }
                    .padding(.top, 5)
                    
                }
                .padding()
                
            }
        }
        .frame(width: 221)
        .background(Color.clear)
    }
}

//struct DetailCard_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailCard(currentPersonInfo: nil)
//    }
//}

struct MyTextField: View {
    var textForUser: String
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 3){
            TextField(textForUser, text: $text)
                .editBackGround()
        }
        
    }
}

extension TextField {
    func editBackGround() -> some View {
        return self
            .padding(2)
            .textFieldStyle(PlainTextFieldStyle())
            .foregroundColor(Color.white)
            .padding(2)
            .border(Color.white.opacity(0.3))
            .cornerRadius(2.4)
    }
}
