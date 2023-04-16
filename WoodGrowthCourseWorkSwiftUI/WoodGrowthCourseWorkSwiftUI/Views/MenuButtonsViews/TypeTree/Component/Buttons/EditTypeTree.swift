//
//  EditTypeTree.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 15.04.2023.
//

import SwiftUI

struct EditTypeTree: View {
    @EnvironmentObject var typeData : TypeTreesData
    @Binding var closeScreen        : pressedButton
    @Binding var currentType        : TypeTreesResult
    @State private var isHover      = false
    @State private var showAlert    = false
    @State private var showMainView = false
    @State private var newNameType  = ""
    @State private var newNote      = ""
    @State private var newPhoto     = ""
    
    init(closeScreen: Binding<pressedButton>, currentType: Binding<TypeTreesResult>) {
        self._currentType = currentType
        self._closeScreen = closeScreen
        self._newNameType = State(initialValue: currentType.wrappedValue.nameType)
        self._newPhoto = State(initialValue: "\(currentType.wrappedValue.photo)")
        self._newNote = State(initialValue: currentType.wrappedValue.notes ?? "")
        self.showMainView = true
    }
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        VStack {
            Spacer()
            
            Text("Редактирование вида.")
                .font(.system(size: 40))
                .bold()
            
            HStack {
                Spacer()
                VStack {
                    closeCard()
                    inputDataView()
                }
                .padding()
                .frame(width: 500, height: 400)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(getGradient(), lineWidth: 3)
                }
                .background(getGradient().opacity(0.05))
                .cornerRadius(20)
                Spacer()
            }
            
            Spacer()
        }
        .alert("Ошибка!", isPresented: $showAlert, actions: {
            Button("OK") { }
        }, message: {
            Text("Заполните данные.")
        })
    }
    
    private func closeCard() -> some View {
        HStack {
            Spacer()
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(isHover ? .red : .white)
                .onTapGesture {
                    closeScreen = .main
                }
                .onHover { hovering in
                    isHover = hovering
                }
                .padding(.bottom, 10)
        }
    }
    
    private func inputDataView() -> some View {
        VStack {
            Spacer()
            Text("Название вида участка.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            
            MyTextField(textForUser: "Название участка", text: $newNameType)
                .padding(.top, -7)
            
            Text("URL фото вида участка.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            MyTextField(textForUser: "URL фото", text: $newPhoto)
                .padding(.top, -7)
            
            Text("Примечание")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
            
            TextEditor(text: $newNote)
                .background(Color.gray.opacity(0.2))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .border(Color.gray)
                .background(Color.white)
                .font(.system(size: 16))
                .padding(.top, -7)
            
            Button("Save") {
                if newNameType == "" || newPhoto == "" {
                    self.showAlert = true
                    return
                }
                
                let sqlString = """
                UPDATE type_tree SET name_type='\(newNameType)',photo='\(newPhoto)',notes='\(newNote)' WHERE type_id=\(currentType.id);
                """
                APIRequest(sqlString)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top)
            
            Spacer()
        }
    }
    
    private func APIRequest(_ sqlString: String) {
        APIManager.shared.updateWithSlash(SQLQuery: sqlString) { data, error in
            guard let _ = data else {
                print("== ERROR FROM AddTypeTree [Button]<Save>", error!)
                showAlert = true
                return
            }

            DispatchQueue.main.async  {
                typeData.refresh { data, error in
                    guard let data = data else {
                        return
                    }
                    if let newCurrent = data.first(where: { $0.id == currentType.id }) {
                        currentType = newCurrent
                    }
                    self.closeScreen = .main
                    
                }
            }
        }

    }
}

struct EditTypeTree_Previews: PreviewProvider {
    static var previews: some View {
        EditTypeTree(closeScreen: .constant(.main), currentType: .constant(TypeTreesResult(id: "0", nameType: "Берёза", notes: "Что-то оченьв важное для описания и тому подобное.", firtilizerName: "Любятова", plotName: "А", countTrees: "100", photo: URL(string: "https://phonoteka.org/uploads/posts/2021-05/1621391291_26-phonoteka_org-p-luntik-fon-27.jpg")!)))
    }
}
