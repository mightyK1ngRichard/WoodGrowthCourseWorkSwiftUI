//
//  TreeCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TreeCard: View {
    @EnvironmentObject var pressedTreeInfo : PressedButtonTree
    var treeInfo                           : TreeResult
    @State private var isHovering          = false
    
    var body: some View {
        VStack() {
            WebImage(url: treeInfo.photo)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .cornerRadius(15)
                .overlay {
                    Circle().stroke(getGradient(), lineWidth: 3)
                }

            VStack {
                Text("№ \(treeInfo.name_tree)")
                    .font(.title)
                    .bold()
                
                Text("**Участок:** \(treeInfo.name_plot ?? "Не задан")")
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
                Text("Y: \(treeInfo.y_begin), \(treeInfo.y_end)")
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
        .overlay {
            RoundedRectangle(cornerRadius: 20).stroke(getGradient(), lineWidth: 2)
        }
        .background(getGradient().opacity(0.1))
        .cornerRadius(20)
        .padding(.vertical, 10)
        .environmentObject(pressedTreeInfo)
    }
}

struct TreeCard_Previews: PreviewProvider {
    static var previews: some View {
        let default1 = PressedButtonTree()
        
        TreeCard(treeInfo: TreeResult(id: "0", name_tree: "1", volume: 100, date_measurements: "2023-02-14T21:00:00.000Z", notes: "привет", name_type: "Берёза", name_plot: "А", x_begin: 1, x_end: 1, y_begin: 1, y_end: 1, photo: URL(string: "https://klike.net/uploads/posts/2023-01/1674189522_3-98.jpg")!, typeID: "0"))
            .environmentObject(default1)
            .onAppear() {
                default1.pressed = true
            }
    }
}
