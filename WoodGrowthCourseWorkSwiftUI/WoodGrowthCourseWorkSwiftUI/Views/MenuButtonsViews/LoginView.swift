//
//  LoginView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var openMenu: OpenMenu
    @State var email    = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(Color.black, lineWidth: 3)
                }
                .padding(.bottom, 40)
                .foregroundColor(.blue)
            
            Text("Добро пожаловать!")
                .font(.largeTitle)
                .addGlowEffect(color1: Color(Color.RGBColorSpace.sRGB, red: 96/255, green: 252/255, blue: 255/255, opacity: 1), color2: Color(Color.RGBColorSpace.sRGB, red: 44/255, green: 158/255, blue: 238/255, opacity: 1), color3: Color(Color.RGBColorSpace.sRGB, red: 0/255, green: 129/255, blue: 255/255, opacity: 1))
            
            
            VStack {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email Address", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .padding(.bottom, 20)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Password", text: $password)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .padding(.bottom, 20)
                Button {
                    // TODO: чекать БД и открывать.
                    openMenu.openMenu = true
                } label: {
                    Text("Вход")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                }.padding(.vertical, 20)
                
            }
            .frame(width: 400)
            
            Spacer()
        }
        .frame(width: 600)
        .background(Image("background")
            .aspectRatio(contentMode: .fit))
        
    }
}

extension View {
    func addGlowEffect(color1:Color, color2:Color, color3:Color) -> some View {
        self
            .foregroundColor(Color(hue: 0.5, saturation: 0.8, brightness: 1))
            .background {
                self
                    .foregroundColor(color1).blur(radius: 0).brightness(0.8)
            }
            .background {
                self
                    .foregroundColor(color2).blur(radius: 4).brightness(0.35)
            }
            .background {
                self
                    .foregroundColor(color3).blur(radius: 2).brightness(0.35)
            }
            .background {
                self
                    .foregroundColor(color3).blur(radius: 12).brightness(0.35)
            }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
