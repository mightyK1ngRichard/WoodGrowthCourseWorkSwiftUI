//
//  Test.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 16.04.2023.
//

import SwiftUI

struct Test: View {
    @ObservedObject var plotData = plotsCardsViewModel()
    
    var body: some View {
        
        GeometryReader { proxy in
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(spacing: 10),
                    GridItem()
                ], spacing: 5) {
                    ForEach(plotData.plotInfo) { card in
                        let width = (proxy.size.width - 30) / 2
                        let height = (proxy.size.height - 30) / 2
                        PlotCard(plotInfo: card, size: (width, height))
                            .frame(width: width, height: height)
                            
                    }
                }
                .padding(10)
            }
        }
        
        
    }
            
        
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
