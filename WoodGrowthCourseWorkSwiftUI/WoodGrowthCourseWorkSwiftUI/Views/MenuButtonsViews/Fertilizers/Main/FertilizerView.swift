//
//  FertilizerView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct FertilizerView: View {
    @State private var pressedCard     = false // Редактор.
    @ObservedObject var fertilizerData = FertilizerData()
    @State private var editingCard     : FertilizerResult?
    
    var body: some View {
        if !fertilizerData.status {
            TurnOffServer()
            
        } else {
            VStack {
                GeometryReader { _ in
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
            .environmentObject(fertilizerData)
        }
    }
}

struct FertilizerView_Previews: PreviewProvider {
    static var previews: some View {
        FertilizerView()
    }
}
