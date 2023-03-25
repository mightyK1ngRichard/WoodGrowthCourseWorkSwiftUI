//
//  FertilizerCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct FertilizerCard: View {
    @Binding var pressedCard     : Bool 
    @Binding var infoCardPressed : FertilizerResult?
    @State private var isHover   = false
    var data                     : FertilizerResult
    
    var body: some View {
        VStack {
            Image(data.typeTree)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 200)
                .cornerRadius(20)
                .shadow(color: .yellow, radius: 5)
            
            Text(data.nameFertilizer.capitalized)
                .font(.system(size: 35))
                .bold()
                .padding(.bottom, 5)
                .offset(y: -13)
            
            VStack(spacing: 3) {
                Text("Цена: \(data.priceFertilizer) ₽")
                Text("Масса: \(data.massFertilizer) м³")
                Text("Вид: \(data.typeTree)")
            }
            .font(.system(size: 16))
        }
        .padding()
        .background(Color.purple.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
            infoCardPressed = data
            pressedCard = true
        }
        .brightness(isHover ? -0.2 : 0)
        .onHover { hovering in
            isHover = hovering
        }
    }
}

struct FertilizerCard_Previews: PreviewProvider {
    static var previews: some View {
        let testData = FertilizerResult(id: "1", nameFertilizer: "Удобрение", priceFertilizer: 1000, massFertilizer: 1000, typeTree: "Дуб")
        
        return FertilizerCard(pressedCard: .constant(false), infoCardPressed: .constant(testData), data: testData)
    }
}
