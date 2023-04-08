//
//  TreeCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import SwiftUI

struct TreeCard: View {
    @State var isHovering                  = false
    @EnvironmentObject var pressedTreeInfo : PressedButtonTree
    var treeInfo                           : TreeResult
    
    var body: some View {
        VStack() {
            Image(treeInfo.name_type)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(15)
                .overlay {
                    Circle().stroke(getGradient(), lineWidth: 3)
                }

            VStack {
                Text("№ \(treeInfo.name_tree)")
                    .font(.title)
                    .bold()
                
                Text("**Участок:** \(treeInfo.name_plot)")
                Text("**Вид:** \(treeInfo.name_type)")
                Text("**Объём:** \(treeInfo.volume)")
            }
            
            Text("**Дата заземления:**")
            Text(correctDate(dateString: treeInfo.date_measurements))
            Spacer()
            VStack {
                Text("**Кординаты:**")
                    .font(.headline)
                Text("X: \(treeInfo.x_begin), \(treeInfo.x_end)")
                Text("Y: \(treeInfo.y_begin), \(treeInfo.x_end)")
            }
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isHovering = hovering
            }
        }
        .onTapGesture {
            pressedTreeInfo.pressed = true
            pressedTreeInfo.treeInfo = treeInfo
        }
        .padding(.vertical, 10)
        .brightness(isHovering ? -0.2 : 0)
        .frame(minWidth: 150, maxWidth: 150, minHeight: 300, maxHeight: 300)
        .border(.white.opacity(0.4))
        .padding(.vertical, 10)
    }
}

struct TreeCard_Previews: PreviewProvider {
    static var previews: some View {
        TreeCard(treeInfo: TreeResult(id: "0", name_tree: "1", volume: 1000, date_measurements: "2023-02-14T21:00:00.000Z", notes: "Дорого", name_type: "Дуб", name_plot: "А", x_begin: 0, x_end: 20, y_begin: 0, y_end: 20))
    }
}
