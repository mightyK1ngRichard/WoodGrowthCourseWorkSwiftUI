//
//  TypeTreeCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TypeTreeCard: View {
    @EnvironmentObject var typeList        : ListTypeTrees
    @EnvironmentObject var typesData       : TypeTreesData
    @EnvironmentObject var treesOfThisType : ListTrees
    @EnvironmentObject var currentCard     : CurrentType
    @Binding var closeEye                  : Bool
    @Binding var showTrees                 : Bool
    @State private var isHover             = false
    @State private var showThisView        = true
    @State private var showAlert           = false
    @State private var alertText           = ""
    @State private var switchView          = pressedButton.main
    
    var body: some View {
        menu()
    }
    
    private func menu() -> some View {
        VStack {
            switch(switchView) {
            case .main:
                mainView()
                
            case .addTypeTree:
                AddTypeTree(closeScreen: $switchView)
                
            case .editTypeTree:
                EditTypeView()
                
            case .addTree:
                AddTreeView()
            }
        }
    }
    
    private func mainView() -> some View {
        VStack {
            getImageWithText()
            Spacer()
            
            if showTrees {
                if !closeEye {
                    if treesOfThisType.trees.count != 0 {
                        getCardsTrees()
                        
                    } else {
                        Text("Деревьев вида \"\(currentCard.currentType.nameType)\" не существует.")
                            .font(.title)
                            .bold()
                    }
                }

            } else {
                ProgressView()
            }
            Spacer()
        }
        .alert("Удаление", isPresented: $showAlert, actions: {
            SecureField("Пароль", text: $alertText)
            Button("Удалить") {
                if alertText == "430133" {
                    let SQLQuery = "DELETE FROM type_tree WHERE type_id=\(currentCard.currentType.id);"
                    APIManager.shared.generalUpdate(SQLQuery: SQLQuery) { data, error in
                        guard let _ = data else {
                            print("== ERROR FROM ScrollViewCard", error!)
                            return
                        }
                        self.typesData.refresh { _, _ in
                            if typesData.types.count != 0 {
                                self.currentCard.currentType = typesData.types[0]
                                self.currentCard.selectedTypeInPicker = typesData.types[0].id
                                
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
    
    private func EditTypeView() -> some View {
        VStack {
            if typeList.status {
                EditTypeTree(closeScreen: $switchView)
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
    }
    
    private func AddTreeView() -> some View {
        VStack {
            if typeList.status {
                AddTreeForType(closeScreen: $switchView)
                
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
    }
    
    private func getImageWithText() -> some View {
        HStack {
            ZStack {
                WebImage(url: currentCard.currentType.photo)
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
                Text("\(currentCard.currentType.nameType)")
                    .font(.system(size: 40))
                Text("**Удобрение:** \(currentCard.currentType.firtilizerName ?? "Не задано")")
                Text("**Примечание:**")
                Text("*\(currentCard.currentType.notes ?? "Описания нету")*")
                    .padding(.trailing)
                Text("**Количество деревьев:** \(currentCard.currentType.countTrees) шт.")
                
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
                    ForEach(treesOfThisType.trees) { tree in
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
 
        let defaultTrees = ListTrees()
        let defaulTypeTrees = ListTypeTrees()
        let defaultypesData = TypeTreesData()
        let defaultCurrentCard = CurrentType()
        
        TypeTreeCard(closeEye: .constant(false), showTrees: .constant(true))
            .environmentObject(defaultTrees)
            .environmentObject(defaulTypeTrees)
            .environmentObject(defaultypesData)
            .environmentObject(defaultCurrentCard)
    }
}


enum pressedButton: String {
    case main         = "main"
    case addTypeTree  = "addTypeTree"
    case addTree      = "addTree"
    case editTypeTree = "EditTypeTree"
}
