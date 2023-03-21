//
//  ContentView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
import AppKit

class OpenMenu: ObservableObject {
    @Published var openMenu = false
}

struct ContentView: View {
    @ObservedObject var openMenu = OpenMenu()
    
    var body: some View {
        HStack {
            if openMenu.openMenu {
                AdminMenuView()
                
            } else {
                SignIn()
            }
        }
        .environmentObject(openMenu)
    }
}

struct SignIn : View {
    @EnvironmentObject var openMenu: OpenMenu
    @State private var isShowingSecondWindow = false
    @State var user = ""
    @State var pressedSighIn = false
    @State var pass = ""
    
    var body : some View{
        VStack {
            Text("Sign In")
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.top,.bottom], 20)
            
            VStack{
                
                VStack(alignment: .leading){
                    
                    VStack(alignment: .leading){
                        
                        Text("Username").font(.headline).fontWeight(.light)
                        
                        HStack() {
                            TextField("Enter Your Username", text: $user)
                                .frame(width:  (NSScreen.main?.frame.width ?? 0) * 0.24)
                            if user != ""{
                                Image("check")
                            }
                            
                        }
                        
                        Divider()
                        
                    }.padding(.bottom, 15)
                    
                    VStack(alignment: .leading){
                        
                        Text("Password").font(.headline).fontWeight(.light)
                        
                        SecureField("Enter Your Password", text: $pass)
                            .frame(width:  (NSScreen.main?.frame.width ?? 0) * 0.24)
                        
                        Divider()
                    }
                    
                }.padding(.horizontal, 6)
                
            }
            .padding()
            
            VStack {
                
                Button(action: {
                    // TODO: чекать БД и открывать.
                    openMenu.openMenu = true
                    print("tup")
                    //                    presentationMode.wrappedValue.dismiss()
                    //                    openSecondView()
                }) {
                    
                    Text("Sign In").foregroundColor(.white).frame(width: 100).padding()
                }
                .background(Color("color"))
                .clipShape(Capsule())
                .padding(.top, 45)
                .sheet(isPresented: $isShowingSecondWindow) {
                    AdminMenuView()
                }
                
                
                Text("(or)").foregroundColor(Color.white.opacity(0.5)).padding(.top,30)
                
                HStack(spacing: 8){
                    
                    Text("Don't Have An Account ?").foregroundColor(Color.white.opacity(0.5))
                    
                    Button(action: {
                        // TODO: сделать авторизацию.
                    }) {
                        
                        Text("Sign Up")
                        
                    }.foregroundColor(.blue)
                    
                }.padding(.top, 25)
                Spacer()
            }
            Spacer()
        }
        .background(Image("authBackGround")
            .resizable()
            .opacity(0.5)
            .background(Color.black)
        )
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
