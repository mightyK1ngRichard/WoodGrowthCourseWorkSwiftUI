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
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(Color(red: 176/255, green: 0, blue: 0), lineWidth: 2)
                        }
                    
                } else {
                    Image(systemName: "photo.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(Color(red: 176/255, green: 0, blue: 0), lineWidth: 3)
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
                .font(.system(size: 14))
                .bold()
                .padding(.bottom, 5)
                .lineLimit(1)
            
            if let phone = data.telephone {
                Text(getCorrectPhone(phoneString: phone) ?? phone)
                    .font(.system(size: 11))
                
            } else {
                Text("Телефон отсутствует")
            }
            
            if let www = data.www {
                Text("\(www)")
                    .underline()
                    .foregroundColor(.blue)
                    .font(.system(size: 11))
                    .frame(width: 130)
                    .lineLimit(1)
            } else {
                Text("Сайт отсутствует")
                    .frame(width: 130)
                    .lineLimit(1)
            }
        }
        .frame(width: 130, height: 200)
    }
}

struct SupplierCard_Previews: PreviewProvider {
    
    static var previews: some View {
        let defaultSupplier = SupplierResult(id: "0", name_supplier: "Boss", telephone: "89167732525", www: URL(string: "https://github.com/mightyK1ngRichard")!, photo: URL(string: "https://kartinkin.net/uploads/posts/2021-07/1625591458_18-kartinkin-com-p-krasivie-anime-tyanki-anime-krasivo-22.jpg")!)
        
        SupplierCard(pressedCard: .constant(false), currentCard: .constant(defaultSupplier), data: defaultSupplier)
    }
}



// LinearGradient(gradient: Gradient(colors: [Color(red: 176/255, green: 0, blue: 0), .blue]), startPoint: .top, endPoint: .bottom)
