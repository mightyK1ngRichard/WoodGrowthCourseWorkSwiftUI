//
//  PlotCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlotCard: View {
    @State private var openEdit       = false
    @State private var isHovering     = false
    @State private var isShowCalendar = false
    @State private var isHoverOnImage = false
    var plotInfo: PlotResult
    
    var body: some View {
        
        if openEdit {
            return AnyView(
                EditPlot(pressedClose: $openEdit)
            )
        }
        
        return AnyView(
            VStack {
                ZStack(alignment: .top) {
                    
                    Image(plotInfo.type_tree)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .brightness(isHoverOnImage ? -0.1 : 0)
                        .onHover { hovering in
                            isHoverOnImage = hovering
                        }

                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .overlay {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing)
                        .opacity(isHoverOnImage ? (isShowCalendar ? 1 : 0.7) : 0)
                        .onHover { hovering in
                            isShowCalendar = hovering
                        }
                        .onTapGesture {
                            // TODO: Лог поливки
                        }
    
                    VStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Дата заземления: ")
                                    .font(.title3)
                                    .bold()
                                    .padding(.top)
                                Text(correctDate(dateString: plotInfo.date))
                                // TODO: удобрение.
                                Text("Удобрение: ")
                                    .font(.title3)
                                    .bold()
                                + Text("Удобрение")
                                
                                Text("Вид: ")
                                    .font(.title3)
                                    .bold()
                                + Text(plotInfo.type_tree)
                                // TODO: Число.
                                Text("Количество деревьев: ")
                                    .font(.title3)
                                    .bold()
                                + Text("20 шт")
                                
                                Text("Адрес: ")
                                    .font(.title3)
                                    .bold()
                                    .padding(.top)

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
                    .frame(width: 500, height: 192)
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
                        .onTapGesture {
                            self.openEdit.toggle()
                        }
                        .brightness(isHovering ? 0.4 : 0)
                        .onHover { hovering in
                            self.isHovering = hovering
                        }
                }
            }
            .frame(width: 500, height: 332)
            .cornerRadius(10)
        )
    }
}

struct PlotCard_Previews: PreviewProvider {
    static var previews: some View {
        PlotCard(plotInfo: PlotResult(id: "1", name: "F", date: "2023-02-14T21:00:00.000Z", address: "Ул. Далеко что жесть", employee: "Вова Степанов", emp_photo: nil, type_tree: "Берёза"))
    }
}

