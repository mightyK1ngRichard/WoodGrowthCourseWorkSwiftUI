//
//  TypeTrees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI


struct TypeTrees: View {
    @ObservedObject var typesData       = TypeTreesData()
    @ObservedObject var treesOfThisType = ListTrees()
    @ObservedObject var typeList        = ListTypeTrees()
    @ObservedObject var currentCard     = CurrentType()
    @ObservedObject var isShow          = ShowScreens()
    
    init() {
        getData()
    }
    
    var body: some View {
        mainView()
    }
    
    private func mainView() -> some View {
        ZStack {
            if isShow.showScreen {
                if !isShow.showSecondView {
                    ZStack {
                        VStack {
                            getPickerWithTypes()
                                .padding(.top)
                            TypeTreeCard()
                        }
                        if !isShow.showScreen {
                            ProgressView()
                        }
                    }
                    
                } else {
                    secondView()
                }
                
            } else {
                TurnOffServer()
            }
        }
        .environmentObject(typesData)
        .environmentObject(treesOfThisType)
        .environmentObject(typeList)
        .environmentObject(currentCard)
        .environmentObject(isShow)
    }
    
    private func getPickerWithTypes() -> some View {
        Picker("", selection: $currentCard.selectedTypeInPicker) {
            ForEach(typesData.types) {
                Text($0.nameType)
            }
        }
        .labelsHidden()
        .pickerStyle(.segmented)
        .padding()
        .onChange(of: currentCard.selectedTypeInPicker) { _ in
            let currentIndex = getDetailInfoUsingTypeName(data: typesData.types, key: currentCard.selectedTypeInPicker)
            self.currentCard.currentType = typesData.types[currentIndex]
            getTreesInThisPlot(currentCard.currentType.id) { data, error in
                guard let data = data else {
                    print("== ERROR FROM TypeTrees [func getPickerWithTypes]", error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.treesOfThisType.trees = data
                }
            }
        }
    }
    
    private func secondView() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Видов деревьев нету.")
                    .font(.system(size: 50))
                Spacer()
            }
            ProgressView()
            Spacer()
        }
    }
    
    // MARK: - API.
    private func getData() {
        typesData.refresh { data, error in
            guard let data = data else {
                print("== ERROR FROM TypeTrees", error!)
                self.isShow.showScreen = false
                return
            }
            
            if data.count != 0 {
                getTreesInThisPlot(data[0].id) { dataTree, errorTree in
                    guard let dataTree = dataTree else {
                        print("== ERROR FROM TypeTrees [func getData]", error!)
                        DispatchQueue.main.async {
                            self.isShow.showScreen = false
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        self.isShow.showScreen = true
                        self.currentCard.selectedTypeInPicker = data[0].id
                        self.currentCard.currentType = data[0]
                        self.treesOfThisType.trees = dataTree
                        self.isShow.showTrees = true
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    isShow.showSecondView = true
                }
            }
        }
    }
    
    private func getTreesInThisPlot(_ typeId: String, completion: @escaping ([TreeResult]?, String?) -> Void) {
        APIManager.shared.getTrees(typeID: typeId) { data, error in
            guard let data = data else {
                print("== ERROR", error!)
                completion(nil, error!)
                return
            }
            var tempData: [TreeResult] = []
            for el in data.rows {
                let info = TreeResult(id: el.tree_id, name_tree: el.name_tree, volume: el.volume, date_measurements: el.date_measurements, notes: el.notes, name_type: el.name_type, name_plot: el.name_plot, x_begin: el.x_begin, x_end: el.x_end, y_begin: el.y_begin, y_end: el.y_end, photo: el.photo)
                    tempData.append(info)
            }
            
            completion(tempData, nil)
        }
    }
}

struct TypeTrees_Previews: PreviewProvider {
    static var previews: some View {
        TypeTrees()
    }
}
