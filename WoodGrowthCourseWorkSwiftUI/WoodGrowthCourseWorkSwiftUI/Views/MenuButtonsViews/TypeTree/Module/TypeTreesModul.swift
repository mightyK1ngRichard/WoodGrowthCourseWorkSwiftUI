//
//  TypeTreesModul.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import Foundation

class TypeTreesData: ObservableObject {
    @Published var types: [TypeTreesResult] = []
    @Published var status                   = true
    
    init() {
        APIManager.shared.getTypesTrees {data, error in
            guard let data = data else {
                print("== ERROR", error!)
                self.status = false
                return
            }
            for el in data.rows {
                let info = TypeTreesResult(id: el.type_id, nameType: el.name_type, notes: el.notes, firtilizerName: el.fertilizer_name, plotName: el.plot_name, countTrees: el.count_trees)
                self.types.append(info)
            }
            print("I am here 0 with \(self.types.count)")
            self.status = true
        }
    }
}

import SwiftUI
struct Temp: View {
    @State private var selectedColor = "Red"
    @State private var showText = false
    
    let colors = ["Red", "Green", "Blue"]
    
    var body: some View {
        VStack {
            Picker("Select a color", selection: $selectedColor) {
                ForEach(colors, id: \.self) {
                    Text($0)
                }
            }
            .padding()
            
            Button(action: {
                self.showText.toggle()
            }) {
                Text("Show Text")
            }
            .padding()
            
            if showText {
                Text("You selected \(selectedColor)")
                    .foregroundColor(getTextColor())
            }
        }
    }
    
    private func getTextColor() -> Color {
        switch selectedColor {
        case "Red":
            return .red
        case "Green":
            return .green
        case "Blue":
            return .blue
        default:
            return .black
        }
    }
}
