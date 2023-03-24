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
        VStack{
            if !pressedTreeInfo.pressed {
                ScrollTrees()
            } else {
                HStack {
                    ScrollTrees()
                    VStack {
                        DetailCardTree(treeInfo: pressedTreeInfo.treeInfo!)
                        Spacer()
                    }
                    .frame(width: 218)
                    .background(getGradient())
                }
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
        if pressedTreeInfo.pressed {
            columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 6)
        } else {
            columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 7)
        }
        return HStack {
            if treesData.treesInfo.count == 0 {
                Spacer()
                VStack() {
                    Spacer()
                    Text("Сервер отключен.")
                        .font(.largeTitle)
                        .foregroundColor(Color.red)
                    Spacer()
                }
                Spacer()
                
            } else {
                GeometryReader { reader in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 5) {
                            ForEach(treesData.treesInfo) {card in
                                TreeCard(treeInfo: card)
                                    .frame(minWidth: 150, maxWidth: 150, minHeight: 300, maxHeight: 300)
                                    .border(.white.opacity(0.4))
                                    .padding(.vertical, 10)
                                
                            }
                        }
                    }
                }
            }
        }
        .environmentObject(treesData)
    
    }
}
