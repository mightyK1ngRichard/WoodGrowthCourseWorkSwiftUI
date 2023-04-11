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
    @Binding var pressedWateringLog       : Bool
    @State private var newPhotoLink       = ""
    @State private var newFullname        = ""
    @State private var newPost            = ""
    @State private var newPhone           = ""
    @State private var wateringLog        : [RowsWateringEmployee] = []
    var currentPersonInfo                 : EmpoyeeResult
    
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
                
                Image(systemName: pressedWateringLog ? "eye.fill" : "eye.slash.fill")
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
                                print("== ERROR: ", error!)
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
            
                Text((getCorrectPhone(phoneString: currentPersonInfo.phone) ?? "Телефон некорректный"))
    
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
            
            if pressedEdit {
                VStack {
                    Group {
                        MyTextField(textForUser: "Ссылка на фото", text: $newPhotoLink)
                        MyTextField(textForUser: "Введите новое ФИО", text: $newFullname)
                        MyTextField(textForUser: "Введите новую должность", text: $newPost)
                        MyTextField(textForUser: "Введите новый телефон", text: $newPhone)
                    }
                    
                    Button {
                        pressedEdit = false
                        
                        // Форматируем для SQL запроса.
                        let commands = [("photo", newPhotoLink), ("full_name", newFullname), ("post", newPost), ("phone_number", newPhone)].filter { $0.1 != "" }
                        
                        // Если ничего не поменяли, выходим.
                        if commands.count == 0 {
                            pressedClose.pressed = false
                            return
                        }
                        let changedInfo = commands.map { "\($0.0)='\($0.1)'" }.joined(separator: ", ")
                        let sqlString = "UPDATE employer SET \(changedInfo) where employer_id=\(currentPersonInfo.id);"
                        
                        APIManager.shared.updateEmployee(SQLQuery: sqlString) { _, error in
                            if let error = error {
                                print("== ERROR:", error)
                            }
                        }

                        pressedClose.pressed = false
                        
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
