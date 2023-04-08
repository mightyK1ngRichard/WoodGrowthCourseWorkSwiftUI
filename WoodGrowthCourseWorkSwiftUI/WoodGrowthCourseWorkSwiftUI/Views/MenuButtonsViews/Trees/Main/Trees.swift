//
//  Trees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

struct Trees: View {
    @EnvironmentObject var pressedTreeInfo: PressedButtonTree
    
    var body: some View {
        HStack{
            ScrollTrees()
            if pressedTreeInfo.pressed {
                VStack {
                    DetailCardTree(treeInfo: pressedTreeInfo.treeInfo!)
                    Spacer()
                }
                .frame(width: 218)
                .background(getGradient())
            }
        }
        .frame(minWidth: 1235)
    }
}

struct ScrollTrees: View {
    @ObservedObject var treesData = treesCardsViewModel()
    @EnvironmentObject var pressedTreeInfo: PressedButtonTree
    
    var body: some View {
        var columns: [GridItem]
        
        // Задаём число карточек в ширину.
        if pressedTreeInfo.pressed {
            columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 6)
        } else {
            columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 7)
        }
        
        return HStack {
            // Сервер отключен.
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
        .environmentObject(treesData)
    
    }
}
