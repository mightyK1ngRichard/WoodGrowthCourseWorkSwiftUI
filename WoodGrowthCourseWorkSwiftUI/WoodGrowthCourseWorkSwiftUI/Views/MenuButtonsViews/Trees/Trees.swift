//
//  Trees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import SwiftUI

struct Trees: View {
    let window                             = NSScreen.main?.visibleFrame
    @EnvironmentObject var pressedTreeInfo : PressedButtonTree
    
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
    }
}

struct ScrollTrees: View {
    var columns                   = Array(repeating: GridItem(.flexible(), spacing: 5), count: 5)
    @ObservedObject var treesData = treesCardsViewModel()
    var body: some View {
        HStack {
            GeometryReader { reader in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        ForEach(treesData.treesInfo) {card in
                            TreeCard(treeInfo: card)
                                .frame(minWidth: 150, maxWidth: 150, minHeight: 300, maxHeight: 300)
<<<<<<< HEAD
                                .border(.black)
=======
                                .border(.white.opacity(0.4))
>>>>>>> fdf76e0 (Update)
                            
                        }
                    }
                }
            }
        }
        .environmentObject(treesData)
    }
}

//struct Trees_Previews: PreviewProvider {
//    static var previews: some View {
//        Trees()
//    }
//}

