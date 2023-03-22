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
<<<<<<< HEAD
    @State private var newVolume           = ""
=======
    @State private var newPost             = ""
    @State private var newVolume           = ""
    @State private var newDate             = ""
    @State private var newX1               = ""
    @State private var newX2               = ""
    @State private var newY1               = ""
    @State private var newY2               = ""
    
>>>>>>> fdf76e0 (Update)
    var body: some View {
        VStack() {
            ZStack {
                Image(treeInfo.name_type)
                    .resizable()
                    .clipShape(Circle())
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(15)
<<<<<<< HEAD
                    .brightness(isHovering ? -0.2 : 0)
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) { // добавление плавности анимации
=======
                    .overlay {
                        Circle().stroke(Color.white, lineWidth: 3)
                    }
                    .brightness(isHovering ? -0.2 : 0)
                    .onHover { hovering in
                        withAnimation(.easeInOut(duration: 0.2)) {
>>>>>>> fdf76e0 (Update)
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
<<<<<<< HEAD
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
=======
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
                VStack {
                    Text("Кординаты:")
                        .font(.headline)
                    Text("X: \(treeInfo.x_begin), \(treeInfo.x_end)")
                    Text("Y: \(treeInfo.y_begin), \(treeInfo.x_end)")
                }
                
>>>>>>> fdf76e0 (Update)
            }
            if pressedEdit {
                VStack {
                    Group {
<<<<<<< HEAD
                        MyTextField(textForUser: "Введите новое имя", text: $newName)
                        MyTextField(textForUser: "Введите новую фамилию", text: $newType)
                        MyTextField(textForUser: "Введите новую должность", text: $newPlot)
                        MyTextField(textForUser: "Введите новый телефон", text: $newVolume)
=======
                        MyTextField(textForUser: "Новый №", text: $newName)
                        MyTextField(textForUser: "Новый участок", text: $newPlot)
                        MyTextField(textForUser: "Новый вид", text: $newType)
                        MyTextField(textForUser: "Новый объём", text: $newVolume)
                        MyTextField(textForUser: "Новая должность", text: $newPost)
                        MyTextField(textForUser: "Новая должность", text: $newDate)
                        
                        MyTextField(textForUser: "Новый X start", text: $newX1)
                        MyTextField(textForUser: "Новый X end", text: $newX2)
                        MyTextField(textForUser: "Новый Y start", text: $newY1)
                        MyTextField(textForUser: "Новый Y end", text: $newY2)
                        
>>>>>>> fdf76e0 (Update)
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
<<<<<<< HEAD
                    
=======
                    Spacer()
>>>>>>> fdf76e0 (Update)
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
