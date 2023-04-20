//
//  DetailCardTree.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailCardTree: View {
    @EnvironmentObject var treesData       : treesCardsViewModel
    @EnvironmentObject var pressedTreeInfo : PressedButtonTree
    @State private var isHovering          = false
    @State private var isHovering2         = false
    @State private var showAlert           = false
    @State private var showAlertDelete     = false
    @State private var pressedEdit         = true //false
    @State private var textInAlert         = ""
    @State private var inputPassword       = ""
    @State private var newName             = ""
    @State private var newType             = ""
    @State private var newVolume           = ""
    @State private var newX1               = ""
    @State private var newX2               = ""
    @State private var newY1               = ""
    @State private var newY2               = ""
    @State private var newDate             = Date()
    @State private var allTypes            = [RowsAllTypeTrees]()
    
    var body: some View {
        MainView
            .onReceive(pressedTreeInfo.$treeInfo) { tree in
                fetchData()
                if let tInfo = tree {
                    self.newName = tInfo.name_tree
                    self.newType = tInfo.typeID
                    self.newVolume = "\(tInfo.volume)"
                    self.newX1 = "\(tInfo.x_begin)"
                    self.newX2 = "\(tInfo.x_end)"
                    self.newY1 = "\(tInfo.y_begin)"
                    self.newY2 = "\(tInfo.y_end)"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = dateFormatter.date(from: tInfo.date_measurements) ?? Date()
                    self.newDate = date
                    
                } else {
                    pressedTreeInfo.pressed = false
                }
            }
            .alert(textInAlert, isPresented: $showAlert) {}
            .alert("Удаление", isPresented: $showAlertDelete, actions: {
                SecureField("Пароль", text: $inputPassword)
                Button("Удалить") {
                    if inputPassword == "\(PasswordForEnter.password)" {
                        if let currentTree = pressedTreeInfo.treeInfo {
                            let SQLQuery = """
                            BEGIN TRANSACTION;
                            DELETE FROM coordinates WHERE tree_id='\(currentTree.id)';
                            DELETE FROM tree WHERE tree_id='\(currentTree.id)';
                            COMMIT;
                            """
                            APIManager.shared.generalUpdate(SQLQuery: SQLQuery) { data, error in
                                guard let _ = data else {
                                    print("== ERROR FROM DetailCardTree func[alert]:", error!)
                                    return
                                }
                                DispatchQueue.main.async {
                                    self.treesData.refresh()
                                    self.pressedTreeInfo.pressed = false
                                }
                            }
                        } else {
                            self.pressedTreeInfo.pressed = false
                        }
                    }
                }
                Button("Отмена", role: .cancel, action: {})
                
            }, message: {
                Text("Введите пароль, чтобы подтвердить право на удаление.")
            })
    }
    
    private var MainView: some View {
        VStack() {
            if let currentTree = pressedTreeInfo.treeInfo {
                typeImage(currentTree: currentTree)
                textOfTree(currentTree: currentTree)
            
                if pressedEdit {
                    inputNewData(currentTree: currentTree)
                }
                
            } else {
                Text("Невозможная ошибка")
                    .task {
                        pressedTreeInfo.pressed = false
                    }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
    
    private func inputNewData(currentTree: TreeResult) -> some View {
        VStack {
            VStack(alignment: .leading) {
                Group {
                    descriptionText("Название")
                    MyTextField(textForUser: "Новый №", text: $newName)

                    descriptionText("Вид дерева")
                    Picker("", selection: $newType) {
                        ForEach(allTypes, id: \.self.type_id) { type in
                            Text(type.name_type)
                        }
                    }
                    .labelsHidden()
                    
                    descriptionText("Объём")
                    MyTextField(textForUser: "Новый объём", text: $newVolume)
                }
                Group {
                    descriptionText("X начала")
                    MyTextField(textForUser: "Новый X start", text: $newX1)
                    descriptionText("X конца")
                    MyTextField(textForUser: "Новый X end", text: $newX2)
                    descriptionText("Y начала")
                    MyTextField(textForUser: "Новый Y start", text: $newY1)
                    descriptionText("Y конца")
                    MyTextField(textForUser: "Новый Y end", text: $newY2)
                }
                
                descriptionText("Дата заземления")
                DatePicker(selection: $newDate, in: ...Date()) {}
                .datePickerStyle(.field)
            }
            
            Button {
                showAlertDelete = true
                
            } label: {
                HStack {
                    Image(systemName: "trash.circle")
                    Text("Удалить")
                        .padding(.horizontal, 8)
                }
            }
            .padding(.top, 5)
            
            /// Кнопка сохранить.
            Button {
                let sqlString = """
                BEGIN TRANSACTION;
                UPDATE tree
                SET name_tree='\(newName)',volume='\(newVolume)',date_measurements='\(correctDateWithTime(newDate))',type_tree_id='\(newType)'
                WHERE tree_id='\(currentTree.id)';
                UPDATE coordinates
                SET x_begin='\(newX1)',y_begin='\(newY1)', x_end='\(newX2)',y_end='\(newY2)'
                WHERE tree_id='\(currentTree.id)';
                COMMIT;
                """
                pullData(SQLQuery: sqlString)
                
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
    
    private func typeImage(currentTree: TreeResult) -> some View {
        ZStack {
            WebImage(url: currentTree.photo)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .cornerRadius(15)
                .overlay {
                    Circle().stroke(Color.white, lineWidth: 3)
                }
                .brightness(isHovering ? -0.2 : 0)
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.isHovering = hovering
                    }
                }
                .onTapGesture {
                    pressedTreeInfo.pressed = false
                }
                .animation(.easeInOut(duration: 0.2), value: isHovering)
                .padding()
            
            Image(systemName: "square.and.pencil")
                .onHover { hovering in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.isHovering2 = hovering
                    }
                }
                .onTapGesture {
                    pressedEdit.toggle()
                }
                .offset(x: 63, y: 85)
                .colorMultiply(isHovering2 ? .yellow : .black)
                .animation(.easeInOut(duration: 0.2), value: isHovering2)
        }
    }
    
    private func textOfTree(currentTree: TreeResult) -> some View {
        Group {
            Text("№ \(currentTree.name_tree)")
                .font(.title)
                .bold()
            Text("Участок: \(currentTree.name_plot ?? "Не задан")")
            Text("Вид: \(currentTree.name_type)")
            Text("Объём: \(currentTree.volume)")
            Text("Дата заземления: ")
            Text(correctDate(dateString: currentTree.date_measurements))
            Text("Кординаты:")
                .font(.headline)
            Text("X: \(currentTree.x_begin), \(currentTree.x_end)")
            Text("Y: \(currentTree.y_begin), \(currentTree.y_end)")
        }
    }
    
    private func fetchData() {
        APIManager.shared.getAllTypeTreesWithoutConditions { data, error in
            guard let data = data else {
                print("== ERROR FROM DetailCardTree func[fetchData]:", error!)
                return
            }
            self.allTypes = data.rows
            
        }
    }
    
    private func pullData(SQLQuery: String) {
        APIManager.shared.updateWithSlash(SQLQuery: SQLQuery) { respondDB, error in
            guard let _ = respondDB else {
                DispatchQueue.main.async {
                    treesData.refresh()
                    pressedTreeInfo.pressed = false
                }
                return
            }
            DispatchQueue.main.async {
                self.textInAlert = "Данные некорректы! Перепроверьте их."
                self.showAlert = true
            }
        }
    }
    
    private func descriptionText(_ text: String) -> some View {
        Text(text)
            .font(.caption)
            .padding(.bottom, -5)
    }
}

struct DetailCardTree_Previews: PreviewProvider {
    static var previews: some View {
        let default1 = PressedButtonTree()
        
        DetailCardTree()
            .environmentObject(default1)
            .onAppear() {
                default1.treeInfo = TreeResult(id: "0", name_tree: "1", volume: 1000, date_measurements: "2023-02-14T21:00:00.000Z", notes: "Дорого", name_type: "Дуб", name_plot: "А", x_begin: 0, x_end: 20, y_begin: 0, y_end: 20, photo: URL(string: "https://klike.net/uploads/posts/2023-01/1674189522_3-98.jpg")!, typeID: "0")
            }
        
    }
}
