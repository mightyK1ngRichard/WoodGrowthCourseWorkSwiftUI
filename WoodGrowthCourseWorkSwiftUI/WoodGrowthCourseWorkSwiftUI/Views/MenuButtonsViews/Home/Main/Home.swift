//
//  Home.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI


struct Home: View {
    @EnvironmentObject var userData : UserData
    
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
    }
    
    func profile() -> some View {
            ZStack {
                Image("profile")
                    .resizable()
                    .frame(height: 400)
                    .aspectRatio(contentMode: .fit)
                
                Rectangle()
                    .frame(height: 230)
                    .offset(y: 135)
                    .foregroundColor(.white)
                
                VStack {
                    if let img = userData.userData.photo {
                        WebImage(url: img)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 150, height: 150)
                            .foregroundColor(.black)
                            .padding(3)
                            .background(.white)
                            .clipShape(Circle())
                        
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 150, height: 150)
                            .foregroundColor(.black)
                            .padding(3)
                            .background(.white)
                            .clipShape(Circle())
                            
                    }
                    
                    Text(userData.userData.firstname + " " + userData.userData.lastname)
                        .font(.system(size: 40, design: .serif))
                        .bold()
                        .padding(.top, -10)
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
        let default1 = UserData()
        Home()
            .environmentObject(default1)
            .onAppear() {
                default1.status = true
            }
    }
}
