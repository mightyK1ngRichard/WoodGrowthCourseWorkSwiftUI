//
//  FertilizerView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct FertilizerView: View {
    @State var pressedCard             = false // Редактор.
    @ObservedObject var fertilizerData = FertilizerData()
    @State var editingCard             : FertilizerResult? = nil
    
    var body: some View {
        VStack {
            GeometryReader { reader in
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(fertilizerData.fertilizerData) { card in
                            FertilizerCard(pressedCard: $pressedCard, infoCardPressed: $editingCard, data: card)
                                .padding()
                        }
                    }
                }
            }
            
            // Вид для редактирования.
            if pressedCard {
                if let currentNameFertilizer = editingCard?.nameFertilizer {
                    VStack {
                        Text("Редактируем данные по \(currentNameFertilizer)")
                            .font(.title)
                        FertilizerEdit(close: $pressedCard)
                        Spacer()
                    }
                } else {
                    Text("Произошла ошибка. Это невозмонжно, но если вдруг вы видите это сообщение, проверьте чтоль интернет, мб БД полетела.")
                }
                
            }
        }
    }
}

struct FertilizerView_Previews: PreviewProvider {
    static var previews: some View {
        FertilizerView(editingCard: FertilizerResult(id: "1", nameFertilizer: "Удобрение", priceFertilizer: 1000, massFertilizer: 1000, typeTree: "Дуб"))
    }
}
