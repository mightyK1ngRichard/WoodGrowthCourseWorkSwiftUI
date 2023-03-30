//
//  TreeCardForTypeTreeView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI

struct TreeCardForTypeTreeView: View {
    var treeInfo : TreeResult
    
    var body: some View {
        VStack() {
            VStack {
                Text("№ \(treeInfo.name_tree)")
                    .font(.title)
                    .bold()
                
                Text("**Участок:** \(treeInfo.name_plot)")
                Text("**Вид:** \(treeInfo.name_type)")
                Text("**Объём:** \(treeInfo.volume)")
            }
            
            Text("***Дата заземления:*** ")
            Text(correctDate(dateString: treeInfo.date_measurements))
            VStack {
                Text("**Кординаты:**")
                    .font(.headline)
                Text("X: \(treeInfo.x_begin), \(treeInfo.x_end)")
                Text("Y: \(treeInfo.y_begin), \(treeInfo.x_end)")
            }
            Image(treeInfo.name_type)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25)
                .cornerRadius(15)
                .overlay {
                    Circle().stroke(getGradient(), lineWidth: 0.5)
                }
        }
        .padding()
        .background(Color.blue.opacity(0.3))
        .cornerRadius(20)
    }
}

struct TreeCardForTypeTreeView_Previews: PreviewProvider {
    static var previews: some View {
        TreeCardForTypeTreeView(treeInfo: TreeResult(id: "0", name_tree: "1", volume: 1000, date_measurements: "2023-02-14T21:00:00.000Z", notes: "Дорого", name_type: "Дуб", name_plot: "А", x_begin: 0, x_end: 20, y_begin: 0, y_end: 20))
    }
}
