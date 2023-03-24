//
//  Plots.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import SwiftUI

struct Plots: View {
    var columns                   = Array(repeating: GridItem(.flexible()), count: 2)
    @ObservedObject var plotData = plotsCardsViewModel()
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(plotData.plotInfo) {card in
                        PlotCard(plotInfo: card)
                            .padding()
                    }
                }
            }
        }
    }
}

struct Plots_Previews: PreviewProvider {
    static var previews: some View {
        Plots()
    }
}
