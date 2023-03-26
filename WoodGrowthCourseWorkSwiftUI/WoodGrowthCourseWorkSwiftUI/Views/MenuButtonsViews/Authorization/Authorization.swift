//
//  Authorization.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 23.03.2023.
//

import SwiftUI

struct Authorization: View {
    @State var isHover             = false
    
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
                BackGround()
                RightSide()
            }
        }
        .ignoresSafeArea()
        .frame(width: 1447, height: 830)
        .background(Image("auth"))
    }
}

struct Authorization_Previews: PreviewProvider {
    static var previews: some View {
        Authorization()
    }
}

struct LeftSide: View {
    var body: some View {
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
}

struct RightSide: View {
    @EnvironmentObject var openMenu : OpenMenu
    @State var email                = ""
    @State var password             = ""
    @State var isSecurePassword     = true
    @State var signUp               = false
    @State private var isHovered    = false
    @State var isHoverSignInButton  = false
    
    var body: some View {
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
                    openMenu.openMenu = true
                }
                .padding(.top, 20)
            
            HStack {
                Text("Don't have an account?")
                Text("Sign up")
                    .bold()
                    .foregroundColor(isHovered ? .blue : .white)
                    .onHover { hovering in
                        self.isHovered = hovering
                    }
                    .onTapGesture {
                        self.signUp = true
                    }
            }
            .padding(.top, 15)
        }
        .frame(width: 860 / 2, height: 1467 / 2)
        .padding(.trailing, 75)
    }
}

struct BackGround: View {
    
    var body: some View {
        HStack {
        }
        .frame(width: 1100 / 2, height: 1467 / 2)
        .background(LinearGradient(colors: [Color(red: 31/255, green: 34/255, blue: 67/255), Color(red: 160/255, green: 44/255, blue: 58/255)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .blur(radius: 15)
        .opacity(0.9)
        .padding(.trailing, 75)
    }
}
