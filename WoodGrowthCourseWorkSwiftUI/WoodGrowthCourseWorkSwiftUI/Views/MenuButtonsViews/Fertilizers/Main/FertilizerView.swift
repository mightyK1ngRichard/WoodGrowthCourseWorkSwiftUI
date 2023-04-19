//
//  FertilizerView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct FertilizerView: View {
    @ObservedObject var fertilizerData = FertilizerData()
    @State private var showEditor      = false
    
    var body: some View {
        if !fertilizerData.status {
            TurnOffServer()
            
        } else {
            VStack {
                FertilizerCards
                
                // Вид для редактирования.
                if showEditor {
                    VStack {
                        Text("Редактируем данные по \(fertilizerData.currentCard?.nameFertilizer ?? "")")
                            .font(.title)
                        FertilizerEdit(close: $showEditor)
                        Spacer()
                    }
                }
            }
            .environmentObject(fertilizerData)
        }
    }
 
    private var FertilizerCards: some View {
        GeometryReader { _ in
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(fertilizerData.fertilizerData) { card in
                        FertilizerCard(isPressedCard: $showEditor, data: card)
                            .padding()
                    }
                }
            }
        }
    }
}

struct FertilizerView_Previews: PreviewProvider {
    static var previews: some View {
        FertilizerView()
    }
}
