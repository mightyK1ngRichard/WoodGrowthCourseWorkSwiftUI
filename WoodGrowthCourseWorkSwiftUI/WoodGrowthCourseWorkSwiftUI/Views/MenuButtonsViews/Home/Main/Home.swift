//
//  Home.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI
import SwiftUICharts

// TODO: Сделать, когда наводишь на графики, чтобы они увеличивались. И мб добавить угловой 3D эффекст.

struct Home: View {
    @ObservedObject var data        = ReportData()
    @EnvironmentObject var userData : UserData
    
    var body: some View {
        if data.status.0 && data.status.1 && data.status.2 {
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
                                /// Количество деревьев на участке.
                                BarChartView(data: ChartData(values: data.trees), title: "Деревья", legend: "Количество")
                                
                                /// Средний бъём древесины на каждый день.
                                LineChartView(data: data.avgVolume, title: "Средний V³", legend: "по дням")
                                    .padding()
                                    .cornerRadius(8)
                                    .shadow(radius: 5)
                                
                                /// Не придумал.
                                MultiLineChartView(data: data.prices, title: "Поставки")
                                    .shadow(color: .white.opacity(0.7), radius: 5)
                            }
                            
                            infoAboutVolume(width: width)
                            
                            
                        } else {
                            TurnOffServer()
                        }
                    }
                    
                }
            }
            .environmentObject(data)
        } else {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                Spacer()
            }
        }
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
                            .aspectRatio(contentMode: .fill)
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
                            .aspectRatio(contentMode: .fit)
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
                            ForEach(data.percentOfGeneral, id: \.self.0) { data in
                                Rings(percent: CGFloat(data.1), plotName: data.0)
                            }
                        }
                    }
                    .frame(width: width)
                    
                }
            }
            .padding()
            
            Text("Общий объём: \(Int(data.totalVolume))м³")
                .font(.system(size: 12, design: .rounded))
                .padding(.horizontal)
        }
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
