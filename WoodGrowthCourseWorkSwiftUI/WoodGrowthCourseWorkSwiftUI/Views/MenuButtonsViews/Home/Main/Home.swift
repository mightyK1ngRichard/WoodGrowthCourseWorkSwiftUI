//
//  Home.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftUICharts

// TODO: Сделать, когда наводишь на графики, чтобы они увеличивались. И мб добавить угловой 3D эффекст.

struct Home: View {
    @EnvironmentObject var userData : UserData
    
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width * 0.55
            ScrollView {
                VStack {
                    if userData.status {
                        profile(width: width)
                        Text("Отчёты")
                            .font(.system(size: 30, design: .serif))
                            .padding(.bottom, 20)
                        
                        HStack {
                            BarChartView(data: ChartData(values: [("А", 100), ("2019 Q1", 200), ("2019 Q2", 300), ("2019 Q3", 400), ("2019 Q4", 500)]), title: "Деревья", legend: "Количество")
                            
                            
                            LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full chart")
                                .padding()
                                .cornerRadius(8)
                                .shadow(radius: 5)
                            
                            MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title")
                                .shadow(color: .white.opacity(0.7), radius: 5)
                        }
                        
                        infoAboutVolume(width: width)
                            
                        
                    } else {
                        TurnOffServer()
                    }
                    
                }
            }
        }
        // TODO: для тестов
//        .frame(height: 1700)
    }
    
    private func profile(width: CGFloat) -> some View {
        HStack() {
            Spacer()
            ZStack {
                Image("profile")
                    .resizable()
                    .frame(height: 300)
                    .aspectRatio(contentMode: .fit)
                
                Rectangle()
                    .frame(height: 230)
                    .offset(y: 135)
                    .foregroundColor(.black)
                
                VStack {
                    if let img = userData.userData.photo {
                        WebImage(url: img)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .foregroundColor(.black)
                            .padding(1)
                            .background(.white)
                            .clipShape(Circle())
                        
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 150, height: 150)
                            .foregroundColor(.black)
                            .padding(1)
                            .background(.black)
                            .clipShape(Circle())
                        
                    }
                    
                    Text(userData.userData.firstname + " " + userData.userData.lastname)
                        .font(.system(size: 30, design: .serif))
                        .bold()
                        .padding(.top, -10)
                        .foregroundColor(.white)
                    
                    
                    Text(userData.userData.post)
                        .font(.system(size: 10, design: .serif))
                        .foregroundColor(.white)
                    
                    
                }
                .offset(y: 50)
            }
            .cornerRadius(20)
            .frame(width: width)
            .shadow(color: .white, radius: 3)
            .padding()
            Spacer()
        }
    }
    
    private func infoAboutVolume(width: CGFloat) -> some View {
        VStack {
            VStack(alignment: .center) {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(30...50, id: \.self) { i in
                                Rings(percent: CGFloat(i))
                            }
                        }
                    }
                    .frame(width: width)
                    
                }
            }
            .padding()
            
            Text("Общий объём: 23000м³")
                .font(.system(size: 12, design: .rounded))
                .padding(.horizontal)
        }

//        .background(getGradient().opacity(0.1))
        .cornerRadius(20)
//        .overlay {
//            RoundedRectangle(cornerRadius: 20).stroke(getGradient(), lineWidth: 3)
//        }
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
