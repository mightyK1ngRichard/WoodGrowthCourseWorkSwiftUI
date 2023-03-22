//
//  TreeCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import SwiftUI

struct TreeCard: View {
    var treeInfo                           : TreeResult
    @State var isHovering                  = false
    @EnvironmentObject var pressedTreeInfo : PressedButtonTree
    
    var body: some View {
        VStack() {
            Image(treeInfo.name_type)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(15)

            VStack {
                Text("№ \(treeInfo.name_tree)")
                    .font(.title)
                    .bold()
                
                Text("Участок: \(treeInfo.name_plot)")
                Text("Вид: \(treeInfo.name_type)")
                Text("Объём: \(treeInfo.volume)")
            }
            
            Text("Дата заземления: ")
            Text(correctDate(dateString: treeInfo.date_measurements))
            Spacer()
            VStack {
                Text("Кординаты:")
                    .font(.headline)
                Text("X: \(treeInfo.x_begin), \(treeInfo.x_end)")
                Text("Y: \(treeInfo.y_begin), \(treeInfo.x_end)")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .brightness(isHovering ? -0.2 : 0)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) { // добавление плавности анимации
                self.isHovering = hovering
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isHovering)
        .onTapGesture {
            pressedTreeInfo.pressed = true
            pressedTreeInfo.treeInfo = treeInfo
        }
    }
}

struct TreeCard_Previews: PreviewProvider {
    static var previews: some View {
        TreeCard(treeInfo: TreeResult(id: "0", name_tree: "1", volume: 1000, date_measurements: "14-03-2003", notes: "Дорого", name_type: "Дуб", name_plot: "А", x_begin: 0, x_end: 20, y_begin: 0, y_end: 20))
    }
}
