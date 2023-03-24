//
//  PlotCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlotCard: View {
    var plotInfo: PlotResult
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image(plotInfo.type_tree)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Spacer()
                            Text("Дата заземления: ")
                                .font(.title3)
                                .bold()
                            Text(correctDate(dateString: plotInfo.date))
                            Spacer()
                            
                            Text("Вид:")
                                .font(.title3)
                                .bold()
                            Text(plotInfo.type_tree)
                            
                            Spacer()
                            Text("Адрес:")
                                .font(.title3)
                                .bold()
                                .padding(.top, 10)
                            
                            Text(plotInfo.address)
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .padding(.leading)
                        
                        Spacer()
                        VStack (alignment: .center) {
                            Spacer()
                            Text("Ответсвенный:")
                                .font(.title3)
                                .bold()
                            
                            if let img = plotInfo.emp_photo {
                                WebImage(url: img)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                                
                            } else {
                                Image(systemName: "person")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(10)
                            }
                            
                            Text(plotInfo.employee)
                                .font(.title)
                                .bold()
                            Spacer()
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                    }
                }
                .frame(width: 500, height: 172)
                .background(.white)
                .offset(y: 144)
                
                Text(plotInfo.name)
                    .padding(.horizontal, 46)
                    .offset(y: -3)
                    .font(.system(size: 70))
                    .background(.black)
                    .clipShape(Circle())
                    .overlay {
                        Circle().stroke(getGradient(), lineWidth: 3)
                    }
                    .offset(y: 98)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 500, height: 332)
        .cornerRadius(10)
    }
}
