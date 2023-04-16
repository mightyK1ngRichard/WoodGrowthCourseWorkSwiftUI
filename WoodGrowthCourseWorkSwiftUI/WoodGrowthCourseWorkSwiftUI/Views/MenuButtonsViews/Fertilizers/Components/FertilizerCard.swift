//
//  FertilizerCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct FertilizerCard: View {
    @Binding var pressedCard     : Bool
    @Binding var infoCardPressed : FertilizerResult?
    @State private var isHover   = false
    var data                     : FertilizerResult
    
    var body: some View {
        VStack {
            if let typeTreeImage = data.photo {
                WebImage(url: typeTreeImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 200)
                    .cornerRadius(20)
                    .shadow(color: .yellow, radius: 5)
            } else {
                Image(systemName: "tree")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
                    .cornerRadius(20)
                    .shadow(color: .yellow, radius: 5)
            }
            
            Text(data.nameFertilizer.capitalized)
                .font(.system(size: 35))
                .bold()
                .padding(.bottom, 5)
                .offset(y: -13)
            
            VStack(spacing: 3) {
                Text("**Цена:** \(data.priceFertilizer) ₽")
                Text("**Масса:** \(data.massFertilizer) м³")
                Text("**Вид:** \(data.typeTree ?? "Нету")")
                Text("**Поставщик:** \(data.nameSupplier)")
            }
            .font(.system(size: 16))
        }
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 10).stroke(getGradient(), lineWidth: 1)
        }
        .background(getGradient().opacity(0.2))
        .cornerRadius(10)
        .brightness(isHover ? -0.2 : 0)
        .onHover { hovering in
            isHover = hovering
        }
        .onTapGesture {
            infoCardPressed = data
            pressedCard = true
        }
    }
}

struct FertilizerCard_Previews: PreviewProvider {
    static var previews: some View {
        let testData = FertilizerResult(id: "1", nameFertilizer: "Удобрение", priceFertilizer: 1000, massFertilizer: 1000, typeTree: "Дуб", nameSupplier: "Леруа Мерлен", photo: URL(string: "https://klike.net/uploads/posts/2023-01/1674189522_3-98.jpg")!)
        
        return FertilizerCard(pressedCard: .constant(false), infoCardPressed: .constant(testData), data: testData)
    }
}
