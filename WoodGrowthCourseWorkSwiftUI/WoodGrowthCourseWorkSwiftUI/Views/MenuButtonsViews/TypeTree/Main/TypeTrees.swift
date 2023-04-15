//
//  TypeTrees.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 30.03.2023.
//

import SwiftUI

struct TypeTrees: View {
    @ObservedObject var typesData     = TypeTreesData()
    @State private var showSecondView = false
    @State private var showScreen     = false
    @State private var selectedType   = ""
    @State private var closeEye       = false
    @State private var showTrees      = true
    @State private var currentCard    = infoForTest
    @State private var treesOfThisType : [TreeResult] = []
    
    var body: some View {
        mainView()
            .padding(.top)
    }
    
    private func mainView() -> some View {
        ZStack {
            if showScreen {
                if !showSecondView {
                    ZStack {
                        VStack {
                            getPickerWithTypes()
                            TypeTreeCard(treesOfThisType: treesOfThisType, currentCard: $currentCard, selectedType: $selectedType, closeEye: $closeEye, showTrees: $showTrees)
                        }
                        if !showScreen {
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
        .frame(minWidth: 600, minHeight: 600)
        .onAppear {
            getData()
        }
    }
    
    private func getPickerWithTypes() -> some View {
        Picker("", selection: $selectedType) {
            ForEach(typesData.types) {
                Text($0.nameType)
            }
        }
        .labelsHidden()
        .pickerStyle(.segmented)
        .padding()
        .onChange(of: selectedType) { _ in
            let currentIndex = getDetailInfoUsingTypeName(data: typesData.types, key: selectedType)
            self.currentCard = typesData.types[currentIndex]
            
            getTreesInThisPlot(currentCard.id) { data, error in
                guard let data = data else {
                    print("== ERROR FROM TypeTrees [func getPickerWithTypes]", error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.treesOfThisType = data
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
                self.showScreen = false
                return
            }
            
            if data.count != 0 {
                getTreesInThisPlot(data[0].id) { dataTree, errorTree in
                    guard let dataTree = dataTree else {
                        print("== ERROR FROM TypeTrees [func getData]", error!)
                        self.showScreen = false
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.selectedType = data[0].id
                        self.currentCard = data[0]
                        self.showScreen = true
                        self.treesOfThisType = dataTree
                        self.showTrees = true
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    showSecondView = true
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
    
    private func getDetailInfoUsingTypeName(data: [TypeTreesResult], key: String) -> Int {
        return data.firstIndex { $0.id == key }!
    }
}

struct TypeTrees_Previews: PreviewProvider {
    static var previews: some View {
        TypeTrees()
    }
}

// Для рисовки во время вёрстки.
private let infoForTest = TypeTreesResult(id: "0", nameType: "B", notes: "", firtilizerName: "Удобрение F", plotName: "Дуб", countTrees: "100", photo: URL(string: "https://phonoteka.org/uploads/posts/2021-05/1621391291_26-phonoteka_org-p-luntik-fon-27.jpg")!)
