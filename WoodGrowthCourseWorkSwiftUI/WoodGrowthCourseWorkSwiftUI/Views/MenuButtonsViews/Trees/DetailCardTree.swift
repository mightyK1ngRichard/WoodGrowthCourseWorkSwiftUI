//
//  DetailCardTree.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import SwiftUI

struct DetailCardTree: View {
    @EnvironmentObject var pressedTreeInfo : PressedButtonTree
    var treeInfo                           : TreeResult
    @State var isHovering                  = false
    @State var isHovering2                 = false
    @State var pressedEdit: Bool           = false
    @State private var newName             = ""
    @State private var newType             = ""
    @State private var newPlot             = ""
    @State private var newVolume           = ""
    var body: some View {
        VStack() {
            ZStack {
                Image(treeInfo.name_type)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
                    .brightness(isHovering ? -0.2 : 0)
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) { // добавление плавности анимации
                            self.isHovering = hovering
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: isHovering)
                    .onTapGesture {
                        pressedTreeInfo.pressed = false
                    }
                Image(systemName: "square.and.pencil")
                    .offset(x: 63, y: 50)
                .colorMultiply(isHovering2 ? .yellow : .black)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.isHovering2 = hovering
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isHovering)
                .onTapGesture {
                    pressedEdit.toggle()
                }
            }
            VStack {
                Text("Участок: \(treeInfo.name_plot)")
                Text("Вид: \(treeInfo.name_type)")
                Text("Имя: \(treeInfo.name_tree)")
                Text("Объём: \(treeInfo.volume)")
            }
            .bold()
            
            Text("Дата заземления: ")
            Text(correctDate(dateString: treeInfo.date_measurements))
            VStack {
                Text("Кординаты:")
                    .font(.title2)
                Text("X_старт: \(treeInfo.x_begin)")
                Text("X_конец: \(treeInfo.x_end)")
                Text("Y_старт: \(treeInfo.y_begin)")
                Text("Y_конец: \(treeInfo.x_end)")
            }
            if pressedEdit {
                VStack {
                    Group {
                        MyTextField(textForUser: "Введите новое имя", text: $newName)
                        MyTextField(textForUser: "Введите новую фамилию", text: $newType)
                        MyTextField(textForUser: "Введите новую должность", text: $newPlot)
                        MyTextField(textForUser: "Введите новый телефон", text: $newVolume)
                    }
                    
                    Button {
                        // TODO: Запрос обновы БД.
                        self.pressedEdit = false
                        print(newName)
                        print(newType)
                        print(newPlot)
                        print(newVolume)
                        
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Сохранить")
                        }
                    }
                    .padding(.top, 5)
                    
                }
                .padding()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct DetailCardTree_Previews: PreviewProvider {
    static var previews: some View {
        DetailCardTree(treeInfo: TreeResult(id: "0", name_tree: "1", volume: 1000, date_measurements: "14-03-2003", notes: "Дорого", name_type: "Дуб", name_plot: "А", x_begin: 0, x_end: 20, y_begin: 0, y_end: 20))
    }
}
