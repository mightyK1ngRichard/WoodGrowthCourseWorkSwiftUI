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
    var currentCard                  : TypeTreesResult
    var treesOfThisType              : [TreeResult]
    @Binding var closeEye            : Bool
    @Binding var showTrees           : Bool
    @State private var isHover       = false
    @State private var showThisView  = true
    
    var body: some View {
        mainView()
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
    
}

struct TypeTreeCard_Previews: PreviewProvider {
    static var previews: some View {
        let tempPhoto = URL(string: "https://phonoteka.org/uploads/posts/2021-05/1621391291_26-phonoteka_org-p-luntik-fon-27.jpg")!
        
        let item1 = TypeTreesResult(id: "0", nameType: "B", notes: "", firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100", photo: tempPhoto)
        
        let tree1 = TreeResult(id: "0", name_tree: "1", volume: 12, date_measurements: "2023-02-14T21:00:00.000Z", notes: nil, name_type: "Берёза", name_plot: "F", x_begin: 10, x_end: 10, y_begin: 10, y_end: 10)
        
        TypeTreeCard(currentCard: item1, treesOfThisType: [tree1, tree1, tree1, tree1], closeEye: .constant(false), showTrees: .constant(true))
    }
}
