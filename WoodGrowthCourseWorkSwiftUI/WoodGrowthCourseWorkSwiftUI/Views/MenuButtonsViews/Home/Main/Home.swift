//
//  Home.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    @ObservedObject var userData = UserData()
    @Binding var email           : String
    @Binding var password        : String
    
    var body: some View {
        VStack {
            if userData.status {
                HStack() {
                    Spacer()
                    profile()
                        .shadow(color: .black, radius: 20)
                        .padding()
                    Spacer()
                }
                Spacer()
            } else {
                TurnOffServer()
            }
            
        }
        .onAppear() {
            APIManager.shared.getUserInfo(user: email, password: password, completion: { data, error in
                guard let data = data else {
                    print("== ERROR: ", error!)
                    self.userData.status = false
                    return
                }
                for el in data.rows {
                    let newUser = UserResult(id: el.userid, login: el.login, password: el.password, photo: el.photo, firstname: el.firstname, lastname: el.lastname, post: el.post)
                    
                    self.userData.userData = newUser
                    self.userData.status = true
                }
            })
        }
    }
    
    func profile() -> some View {
        ZStack {
            Image("profile")
                .resizable()
                .frame(height: 300)
                .aspectRatio(contentMode: .fit)
            
            Rectangle()
                .frame(height: 150)
                .offset(y: 100)
                .foregroundColor(.white)
            
            VStack {
                if let img = userData.userData.photo {
                    WebImage(url: img)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .padding(3)
                        .background(.white)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .foregroundColor(.black)
                        .padding(3)
                        .background(.white)
                        .clipShape(Circle())
                }
                
                Text(userData.userData.firstname + " " + userData.userData.lastname)
                    .font(.system(size: 40, design: .serif))
                    .bold()
                    .padding(.top, -15)
                    .foregroundColor(.black)

                
                Text(userData.userData.post)
                    .font(.system(size: 20, design: .serif))
                    .foregroundColor(.black)
                
                    
            }
            .offset(y: 50)
            
        }
        .frame(width: 800)
        .cornerRadius(20)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(email: .constant("dimapermyakov55@gmail.com"), password: .constant("boss"))
    }
}
