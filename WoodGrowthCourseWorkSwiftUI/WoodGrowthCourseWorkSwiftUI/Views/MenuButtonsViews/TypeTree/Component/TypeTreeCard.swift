//
//  TypeTreeCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TypeTreeCard: View {
    @EnvironmentObject var typesData : TypeTreesData
    var treesOfThisType              : [TreeResult]
    @Binding var currentCard         : TypeTreesResult
    @Binding var selectedType        : String
    @Binding var closeEye            : Bool
    @Binding var showTrees           : Bool
    @State private var isHover       = false
    @State private var showThisView  = true
    @State private var showAlert     = false
    @State private var alertText     = ""
    @State private var switchView    : pressedButton = .main
    
    var body: some View {
        switch(switchView) {
        case .main:
            mainView()
            
        case .addTypeTree:
            AddTypeTree(closeScreen: $switchView)
            
        case .editTypeTree:
            EditTypeTree(closeScreen: $switchView, currentType: $currentCard)
            
        case .addTree:
            AddTreeForType()
        }
    }
    
    private func mainView() -> some View {
        VStack {
            getImageWithText()
            Spacer()
            
            if showTrees {
                if !closeEye {
                    if treesOfThisType.count != 0 {
                        getCardsTrees()
                        
                    } else {
                        Text("Деревьев вида \"\(currentCard.nameType)\" не существует.")
                            .font(.title)
                            .bold()
                    }
                }

            } else {
                ProgressView()
            }
            Spacer()
        }
        .frame(minHeight: 600)
        .alert("Удаление", isPresented: $showAlert, actions: {
            SecureField("Пароль", text: $alertText)
            Button("Удалить") {
                if alertText == "430133" {
                    let SQLQuery = "DELETE FROM type_tree WHERE type_id=\(currentCard.id);"
                    APIManager.shared.generalUpdate(SQLQuery: SQLQuery) { data, error in
                        guard let _ = data else {
                            print("== ERROR FROM ScrollViewCard", error!)
                            return
                        }
                        self.typesData.refresh { _, _ in
                            if typesData.types.count != 0 {
                                self.currentCard = typesData.types[0]
                                self.selectedType = typesData.types[0].id
                                
                            } else {
                                // TODO: Если не будет лень, сделай тут переключение флага, когда типов не осталось.
                            }
                        }
                        
                    }
                }
            }
            Button("Отмена", role: .cancel, action: {})
            
        }, message: {
            Text("Введите пароль, чтобы подтвердить право на удаление.")
        })
    }
    
    private func getImageWithText() -> some View {
        HStack {
            ZStack {
                WebImage(url: currentCard.photo)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onHover { hovering in
                        isHover = hovering
                    }
                    .clipShape(Circle())
                    .frame(width: 200, height: 200)
                    .overlay {
                        Circle().stroke(getGradient(), lineWidth: 3)
                    }
                    .brightness(isHover ? -0.6 : 0)
                    
                if isHover {
                    Image(systemName: closeEye ? "eye.slash" : "eye")
                        .resizable()
                        .frame(width: 120, height: 90)
                        .onHover { hovering in
                            isHover = hovering
                        }
                        .onTapGesture {
                            closeEye.toggle()
                        }
                }
            }
            
            VStack (alignment: .leading, spacing: 5) {
                Text("\(currentCard.nameType)")
                    .font(.system(size: 40))
                Text("**Удобрение:** \(currentCard.firtilizerName ?? "Не задано")")
                Text("**Примечание:**")
                Text("*\(currentCard.notes ?? "Описания нету")*")
                Text("**Количество деревьев:** \(currentCard.countTrees) шт.")
                
                HStack {
                    
                    updateButton(title: "Вид дерева", imageName: "plus.circle") {
                        switchView = .addTypeTree
                    }
                    updateButton(title: "Удалить вид", imageName: "trash.circle") {
                        showAlert = true
                    }
                    updateButton(title: "Изм. вид", imageName: "square.and.pencil.circle") {
                        switchView = .editTypeTree
                    }
                    updateButton(title: "Новое дерево", imageName: "plus.circle") {
                        switchView = .addTree
                    }
                }

            }
            .padding(.leading, 30)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
    }
    
    private func getCardsTrees() -> some View {
        HStack (alignment: .center) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(treesOfThisType) { tree in
                        TreeCardForTypeTreeView(treeInfo: tree)
                    }
                }
            }
            .padding(.top, 50)
        }
        .frame(width: 987)
    }
    
    private func updateButton(title: String, imageName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
            
        } label: {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                .frame(width: 20, height: 20)
                
                Text(title)
                    .frame(width: 53)
                    .multilineTextAlignment(.center)
                    
            }
            .padding(10)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(getGradient().opacity(0.6), lineWidth: 3)
            }
            .background(getGradient().opacity(0.1))
            .cornerRadius(15)
            
        }
        .buttonStyle(.plain)
        .padding(.top, 10)
        
        
    }
}

struct TypeTreeCard_Previews: PreviewProvider {
    static var previews: some View {
        let tempPhoto = URL(string: "https://phonoteka.org/uploads/posts/2021-05/1621391291_26-phonoteka_org-p-luntik-fon-27.jpg")!
        
        let item1 = TypeTreesResult(id: "0", nameType: "B", notes: "", firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100", photo: tempPhoto)
        
        let tree1 = TreeResult(id: "0", name_tree: "1", volume: 12, date_measurements: "2023-02-14T21:00:00.000Z", notes: nil, name_type: "Берёза", name_plot: "F", x_begin: 10, x_end: 10, y_begin: 10, y_end: 10, photo: URL(string: "https://klike.net/uploads/posts/2023-01/1674189522_3-98.jpg")!)
        
        TypeTreeCard(treesOfThisType: [tree1, tree1, tree1, tree1, tree1, tree1], currentCard: .constant(item1), selectedType: .constant(item1.id), closeEye: .constant(false), showTrees: .constant(true))
    }
}

enum pressedButton: String {
    case main         = "main"
    case addTypeTree  = "addTypeTree"
    case addTree      = "addTree"
    case editTypeTree = "EditTypeTree"
}

