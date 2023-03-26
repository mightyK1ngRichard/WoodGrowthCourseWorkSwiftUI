//
//  SupplierCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SupplierCard: View {
    @State private var isHover = false
    @Binding var pressedCard   : Bool
    @Binding var currentCard   : SupplierResult?
    var data                   : SupplierResult
    
    var body: some View {
        VStack {
            
            Group {
                if let photo = data.photo {
                    WebImage(url: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .top, endPoint: .bottom)
                                            , lineWidth: 3)
                        }

                } else {
                    Image(systemName: "photo.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(LinearGradient(gradient: Gradient(colors: [.purple, .pink]), startPoint: .top, endPoint: .bottom)
                                            , lineWidth: 3)
                        }
                }
            }
            .brightness(isHover ? -0.2 : 0)
            .onHover { hovering in
                isHover = hovering
            }
            .onTapGesture {
                pressedCard = true
                currentCard = data
            }
            
            Text(data.name_supplier)
                .font(.system(size: 22))
                .bold()
                .padding(.bottom, 5)
                .lineLimit(1)
            if let phone = data.telephone {
                Text(getCorrectPhone(phoneString: phone) ?? phone)
            } else {
                Text("Телефон отсутствует")
            }
            
            if let www = data.www {
                Text("\(www)")
                    .underline()
                    .foregroundColor(.blue)
                    .frame(width: 130)
                    .lineLimit(1)
            } else {
                Text("Сайт отсутствует")
                    .frame(width: 130)
                    .lineLimit(1)
            }
        }
        .frame(width: 150, height: 250)
    }
}

//struct SupplierCard_Previews: PreviewProvider {
//    static var previews: some View {
//        SupplierCard(data: SupplierResult(id: "0", name_supplier: "Перекрёсток", telephone: "89168559942", www: nil, photo: nil))
//    }
//}
