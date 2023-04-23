//
//  DetailCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 21.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailCard: View {
    @EnvironmentObject var allDataEmp   : employeesCardsViewModel
    @EnvironmentObject var pressedClose : PressedButtonDetailView
    @State var pressedEdit              = false
    @State private var isHovering       = false
    @State private var isHoveringPhoto  = false
    @State private var isHoveringWater  = false
    @State private var showAlert        = false
    @State private var textInAlert      = ""
    @State private var newPhotoLink     = ""
    @State private var newFullname      = ""
    @State private var newPost          = ""
    @State private var newPhone         = ""
    @State private var wateringLog      : [RowsWateringEmployee] = []
    @Binding var pressedWateringLog     : Bool
    var currentPersonInfo               : EmpoyeeResult
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        VStack {
            imagesSystem()
            imagesView()
            
            Text(currentPersonInfo.fullName)
                .padding(0)
                .font(.title)
                .bold()
            Text(currentPersonInfo.post)
            Text((getCorrectPhone(phoneString: currentPersonInfo.phone) ?? "Телефон некорректный"))
            
            if pressedWateringLog {
                watchWateringLogView()
            }
            
            if pressedEdit {
                editionInfoOfEmployee()
            }
        }
        .frame(width: 221)
        .alert("Ошибка!", isPresented: $showAlert, actions: {
            Button("OK") { }
        }, message: {
            Text(textInAlert)
        })
    }
    
    private func imagesSystem() -> some View {
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
                        DispatchQueue.main.async {
                            self.wateringLog = data.rows
                        }
                    }
                }
        }
    }
    
    private func imagesView() -> some View {
        Group {
            if let image = currentPersonInfo.ava {
                WebImage(url: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
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
    }
    
    private func editionInfoOfEmployee() -> some View {
        VStack {
            Group {
                MyTextField(textForUser: "Ссылка на фото", text: $newPhotoLink)
                MyTextField(textForUser: "Введите новое ФИО", text: $newFullname)
                MyTextField(textForUser: "Введите новую должность", text: $newPost)
                MyTextField(textForUser: "Введите новый телефон", text: $newPhone)
            }
            
            Button {
                if newPhotoLink == "" {
                    pullData()
                    
                } else {
                    guard let link = URL(string: newPhotoLink) else {
                        self.textInAlert = "Вводите ссылку на фото! А не что-то там другое."
                        self.showAlert = true
                        return
                    }
                    
                    isPhotoURLValid(url: link) { isValid in
                        if isValid {
                            pullData()
                            
                        } else {
                            self.textInAlert = "Приложение не может обработать ссылку на это фото! Введите другую ссылку!"
                            self.showAlert = true
                            return
                        }
                    }
                }
                
            } label: {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Сохранить")
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(.white.opacity(0.2))
                .cornerRadius(20)
            }
            .buttonStyle(.plain)
            .padding(.top, 5)
            
        }
        .padding()
    }
    
    private func pullData() {
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
        
        updateData(sqlString)
    }
    
    private func watchWateringLogView() -> some View {
        VStack {
            Text("Даты поливки:")
                .bold()
            if wateringLog.count == 0 {
                Text("Участок не поливали.")
                
            } else {
                ForEach(wateringLog, id: \.self.date_) {
                    Text(correctDate(dateString: $0.date_))
                        .padding(.horizontal)
                }
            }
            
        }.padding(.top, 10)
    }
    
    private func updateData(_ sqlString: String) {
        APIManager.shared.updateWithSlash(SQLQuery: sqlString) { data, error in
            if let _ = data {
                DispatchQueue.main.async {
                    self.textInAlert = "При заполнении базы данных произошла ошибка. Данные некорректны, перепроверьте их!"
                    self.showAlert = true
                }
                return
            }
            
            DispatchQueue.main.async {
                self.allDataEmp.refresh()
                self.pressedClose.pressed = false
            }
        }
    }
}

struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(pressedWateringLog: .constant(true), currentPersonInfo: EmpoyeeResult(id: "0", fullName: "Дмитриц Цуприков", phone: "89134535355", post: "Лесник", ava: URL(string: "https://sun9-69.userapi.com/impg/kUbiMF3vZqXa4T-t8L4Y-Gpk41kyavZzpRVDFA/bdY6Bf5sNEM.jpg?size=1080x1350&quality=95&sign=19f6fbd588569d29ea8c274c515037bc&type=album")!, namePlot: "А", nameType: "Дуб"))
    }
}
