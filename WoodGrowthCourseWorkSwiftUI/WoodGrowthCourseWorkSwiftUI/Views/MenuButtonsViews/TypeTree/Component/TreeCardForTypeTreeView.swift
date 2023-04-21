//
//  TreeCardForTypeTreeView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TreeCardForTypeTreeView: View {
    @EnvironmentObject var treesOfThisType : ListTrees
    @EnvironmentObject var currentType     : CurrentType
    @EnvironmentObject var typeData        : TypeTreesData
    var treeInfo                           : TreeResult
    @State private var isHover             = false
    @State private var showAlertDelete     = false
    @State private var textInAlert         = ""
    @State private var inputPassword       = ""
    
    var body: some View {
        VStack() {
            VStack {
                Text("№ \(treeInfo.name_tree)")
                    .font(.title)
                    .bold()
                
                Text("**Участок:** \(treeInfo.name_plot ?? "Не задан")")
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
            
            WebImage(url: treeInfo.photo)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25)
                .cornerRadius(15)
                .overlay {
                    Circle().stroke(getGradient(), lineWidth: 0.5)
                    Image(systemName: "trash.fill")
                        .foregroundColor(isHover ? Color(red: 176/255, green: 0, blue: 0) : .black.opacity(0))
                }
                .onHover { hovering in
                    self.isHover = hovering
                }
                .onTapGesture {
                    self.showAlertDelete = true
                }
        }
        .padding()
        .background(Color(red: 0, green: 105/255, blue: 87/255).opacity(0.6))
        .cornerRadius(20)
        .alert("Удаление", isPresented: $showAlertDelete, actions: {
            SecureField("Пароль", text: $inputPassword)
            Button("Удалить") {
                if inputPassword == "\(PasswordForEnter.password)" {
                    let SQLQuery = """
                    BEGIN TRANSACTION;
                    DELETE FROM coordinates WHERE tree_id='\(treeInfo.id)';
                    DELETE FROM tree WHERE tree_id='\(treeInfo.id)';
                    COMMIT;
                    """
                    APIManager.shared.generalUpdate(SQLQuery: SQLQuery) { data, error in
                        guard let _ = data else {
                            print("== ERROR FROM DetailCardTree func[alert]:", error!)
                            return
                        }
                        
                        treesOfThisType.refresh(typeID: currentType.currentType.id)
                        typeData.refresh { _, _ in
                            let currentIndex = getDetailInfoUsingTypeName(data: typeData.types, key: currentType.selectedTypeInPicker)
                            DispatchQueue.main.async  {
                                self.currentType.currentType = typeData.types[currentIndex]
                            }
                        }
                    }
                }
            }
            Button("Отмена", role: .cancel, action: {})
            
        }, message: {
            Text("Поддтвердите права доступа для удаления дерева №\(treeInfo.name_tree).")
        })
    }
}

struct TreeCardForTypeTreeView_Previews: PreviewProvider {
    static var previews: some View {
        let default1 = ListTrees()
        let default2 = TypeTreesData()
        let default4 = CurrentType()
        
        TreeCardForTypeTreeView(treeInfo: TreeResult(id: "0", name_tree: "1", volume: 1000, date_measurements: "2023-02-14T21:00:00.000Z", notes: "Дорого", name_type: "Дуб", name_plot: "А", x_begin: 0, x_end: 20, y_begin: 0, y_end: 20, photo: URL(string: "https://klike.net/uploads/posts/2023-01/1674189522_3-98.jpg")!, typeID: "0"))
            .environmentObject(default1)
            .environmentObject(default2)
            .environmentObject(default4)
    }
}
