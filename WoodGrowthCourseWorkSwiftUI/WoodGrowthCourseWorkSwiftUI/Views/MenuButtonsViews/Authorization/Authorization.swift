//
//  Authorization.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 23.03.2023.
//

import SwiftUI

struct Authorization: View {
    @EnvironmentObject var userData        : UserData
    @State private var email               = ""
    @State private var password            = ""
    @State private var firstname           = ""
    @State private var lastname            = ""
    @State private var linkToPhoto         = ""
    @State private var textInAlert         = ""
    @State private var isSecurePassword    = true
    @State private var pressedSignup       = false //false
    @State private var isHovered           = false
    @State private var isHoverSignInButton = false
    @State private var isHover             = false
    @State private var showAlert           = false
    @State private var showProgressView    = false
    
    var body: some View {
        HStack {
            ZStack {
                HStack {
                    Image("logo")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(Color.black, lineWidth: 3)
                        }
                    
                    Text("mightyK1ngRichard")
                        .font(.title)
                }
                .offset(x: -275, y: -375)
                .brightness(isHover ? -0.2 : 0)
                .onHover { hovering in
                    self.isHover = hovering
                }
                LeftSide()
            }
            
            ZStack {
                BackGround
                if !pressedSignup {
                    RightSide()
                } else {
                    SignUpView()
                }
            }
        }
        .ignoresSafeArea()
        .frame(width: 1447, height: 830)
        .background(Image("auth"))
        .alert(textInAlert, isPresented: $showAlert) {}
    }
    
    private func LeftSide() -> some View {
        HStack {
            VStack (alignment: .leading, spacing: 4) {
                Spacer()
                Text("Welcome!")
                Text("To Our Wood Business.")
            }
            .font(.system(size: 60))
            .bold()
            Spacer()
        }
        .padding(.leading, 100)
        .padding(.bottom, 200)
    }
    
    private func RightSide() -> some View {
        VStack(spacing: 0) {
            Text("Sign In")
                .bold()
                .offset(y: -90)
                .font(.system(size: 50))
            
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                TextField("Email", text: $email)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
            .padding(.bottom, 20)
            
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                if isSecurePassword {
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                } else {
                    TextField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                Image(systemName: isSecurePassword ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        isSecurePassword.toggle()
                    }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(10)
            .padding(.bottom, 20)
            
            ZStack {
                Text("Sign In")
                    .frame(width: 425, height: 35)
                    .foregroundColor(.white)
                    .background(Color(red: 195 / 255, green: 13 / 255, blue: 67 / 255))
                    .cornerRadius(10)
                    .brightness(isHoverSignInButton ? -0.3 : 0)
                    .onHover(perform: { hovering in
                        self.isHoverSignInButton = hovering
                    })
                    .onTapGesture {
                        self.showProgressView = true
                        pressedSignIn()
                    }
                    .padding(.top, 20)
                
                /// Анимации загрузки.
                if showProgressView {
                    VStack {
                        ProgressView()
                        Text("Подключение к БД...")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                    .offset(y: 150)
                }
            }
                
            HStack {
                Text("Don't have an account?")
                Button {
                    self.pressedSignup = true
                    
                } label: {
                    Text("Sign up")
                        .bold()
                        .foregroundColor(isHovered ? .blue : .white)
                        .onHover { hovering in
                            self.isHovered = hovering
                        }
                }
                .buttonStyle(.plain)

            }
            .padding(.top, 15)
        }
        .frame(width: 860 / 2, height: 1467 / 2)
        .padding(.trailing, 75)
    }
    
    private func SignUpView() -> some View {
        ZStack {
            VStack {
                Text("Register")
                    .bold()
                    .offset(y: -90)
                    .font(.system(size: 50))
                
                /// Ввод email.
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                
                ///  Ввод ФИО.
                HStack {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                        TextField("Firstname", text: $firstname)
                    }
                    .padding()
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.gray)
                        TextField("Firstname", text: $lastname)
                    }
                    .padding()
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                }
                
                /// Фото.
                HStack {
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                    TextField("Link to photo", text: $linkToPhoto)
                }
                .padding()
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                
                /// Ввод пароля.
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                    if isSecurePassword {
                        SecureField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                    } else {
                        TextField("Password", text: $password)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    Image(systemName: isSecurePassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            isSecurePassword.toggle()
                        }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                
                
                /// Кнопка зарегистрироваться.
                Text("Sign Up")
                    .frame(width: 425, height: 35)
                    .foregroundColor(.white)
                    .background(Color(red: 195 / 255, green: 13 / 255, blue: 67 / 255))
                    .cornerRadius(10)
                    .brightness(isHoverSignInButton ? -0.3 : 0)
                    .onHover(perform: { hovering in
                        self.isHoverSignInButton = hovering
                    })
                    .onTapGesture {
                        self.showProgressView = true
                        
                        if email == "" || password == "" || firstname == "" || lastname == "" {
                            textInAlert = "Заполните все данные!"
                            self.showAlert = true
                            return
                        }
                        
                        guard let link = URL(string: linkToPhoto) else {
                            self.textInAlert = "Ссылка некорректна!"
                            self.showAlert = true
                            return
                        }
                        
                        isPhotoURLValid(url: link) { isValid in
                            if isValid {
                                let sqlCommand = """
                                INSERT INTO users (login, password, photo, firstname, lastname, post)
                                VALUES ('\(email)', '\(password)', '\(link)', '\(firstname)', '\(lastname)', 'Пользователь');
                                """
                                pressedSignUp(SQLQuery: sqlCommand)
                                
                            } else {
                                self.textInAlert = "Приложение не может обработать ссылку на эту фоторграфию. Предоставьте другую ссылку."
                                self.showAlert = true
                                return
                            }
                        }
                    }
                    .padding(.top, 20)
                 
                
            }
            .frame(width: 860 / 2, height: 1467 / 2)
            .padding(.trailing, 75)
            
            Button {
                self.pressedSignup = false
                self.showProgressView = false
                print("TAp!!!")
                
            } label: {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("Back")
                }
                .foregroundColor(Color(red: 165/255, green: 165/255, blue: 253/255))
            }
            .offset(x: -250, y: -320)
            .buttonStyle(.plain)

        }
    }
    
    private func pressedSignIn() {
        if email == "" || password == "" {
            // TODO: расскоментировать при завершении курсовой.
//                        showAlert = true
//                        return
            email = "dimapermyakov55@gmail.com"
            password = "boss"
        }
        
        APIManager.shared.getUserInfo(user: email, password: password, completion: { data, response, error  in
            
            guard let data = data else {
                print("== ERROR: ", error!)
                DispatchQueue.main.async {
                    self.userData.status = false
                }
                return
            }
            
            for el in data.rows {
                let newUser = UserResult(id: el.userid, login: el.login, password: el.password, photo: el.photo, firstname: el.firstname, lastname: el.lastname, post: el.post)
                
                DispatchQueue.main.async {
                    self.userData.userData = newUser
                    self.showProgressView = false
                    self.userData.status = true
                }
            }
            
            if !userData.status {
                DispatchQueue.main.async {
                    self.showProgressView = false
                    textInAlert = "Неверный логин или пароль!"
                    self.showAlert = true
                    self.email = ""
                    self.password = ""
                }
            }
            
            
        })
    }
    
    private func pressedSignUp(SQLQuery: String) {
        APIManager.shared.updateWithSlash(SQLQuery: SQLQuery) { resp, error in
            guard let _ = resp else {
                DispatchQueue.main.async {
                    self.isSecurePassword = true
                    self.password = ""
                    self.showProgressView = false
                    self.pressedSignup = false
                }
                return
            }
            DispatchQueue.main.async {
                self.textInAlert = "Введённая элеткронная почта уже существует!"
                self.showAlert = true
            }
        }

    }
    private var BackGround: some View {
        HStack {
        }
        .frame(width: 1100 / 2, height: 1467 / 2)
        .background(LinearGradient(colors: [Color(red: 31/255, green: 34/255, blue: 67/255), Color(red: 160/255, green: 44/255, blue: 58/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .blur(radius: 15)
        .opacity(0.9)
        .padding(.trailing, 75)
    }
}

struct Authorization_Previews: PreviewProvider {
    static var previews: some View {
        let default1 = UserData()
        Authorization()
            .environmentObject(default1)
    }
}
