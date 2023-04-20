//
//  Trees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

struct Trees: View {
    @ObservedObject var pressedTreeInfo = PressedButtonTree()
    @ObservedObject var treesData       = treesCardsViewModel()
    
    var body: some View {
        HStack{
            ScrollTrees
            
            if pressedTreeInfo.pressed {
                VStack {
                    DetailCardTree()
                    Spacer()
                }
                .frame(width: 218)
                .background(getGradient())
            }
        }
        .environmentObject(pressedTreeInfo)
        .environmentObject(treesData)
        .frame(minWidth: 1235)
    }
    
    private var ScrollTrees: some View {
        var columns: [GridItem]
        
        /// Задаём число карточек в ширину.
        if pressedTreeInfo.pressed {
            columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 6)
        } else {
            columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 7)
        }
        
        return HStack {
            /// Сервер отключен.
            if !treesData.parseStatus {
                TurnOffServer()
                
            } else {
                GeometryReader { reader in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(treesData.treesInfo) {card in
                                TreeCard(treeInfo: card)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Trees_Previews: PreviewProvider {
    static var previews: some View {
        Trees()
    }
}
