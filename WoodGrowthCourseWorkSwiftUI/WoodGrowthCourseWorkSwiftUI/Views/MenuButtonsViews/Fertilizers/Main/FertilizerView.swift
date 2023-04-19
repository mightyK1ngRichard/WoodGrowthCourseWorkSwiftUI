//
//  FertilizerView.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI

struct FertilizerView: View {
    @ObservedObject var fertilizerData  = FertilizerData()
    @State private var showEditor       = EditOrAdd.none
    @State private var searchedData     : [FertilizerResult] = []
    @State private var search           = ""
    
    
    var body: some View {
        if !fertilizerData.status {
            TurnOffServer()
            
        } else {
            VStack {
                searchBar
                
                switch(showEditor) {
                case .none:
                    FertilizerCards
                    
                case .addFertilizer:
                    FertilizerCards
                    AddView
                    
                case .editFertilizer:
                    FertilizerCards
                    EditView
                }
            }
            .environmentObject(fertilizerData)
        }
    }
 
    private var EditView: some View {
        VStack {
            Text("Редактируем данные по \(fertilizerData.currentCard?.nameFertilizer ?? "")")
                .font(.title)
            FertilizerEdit(close: $showEditor)
            Spacer()
        }
    }
    
    private var AddView: some View {
        VStack {
            Text("Добавление удобрения")
                .font(.title)
            AddendumFertilzer(close: $showEditor)
            Spacer()
        }
    }
    
    private var FertilizerCards: some View {
        GeometryReader { _ in
            VStack {
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(searchedData.count != 0 ? searchedData : fertilizerData.fertilizerData) { card in
                            FertilizerCard(isPressedCard: $showEditor, data: card)
                                .padding()
                        }
                    }
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                TextField("Введите название удобрения", text: $search) {
                    self.searchedData = self.fertilizerData.fertilizerData.filter { $0.nameFertilizer.lowercased().contains(self.search.lowercased()) }
                }
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(Color.white)
                .font(.system(size: 14, design: .serif))
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.gray
                .opacity(0.7))
            .cornerRadius(10)
    
            Button {
                // TODO: Сделать
                
                
            } label: {
                Image(systemName: "slider.vertical.3")
                    .foregroundColor(Color.black)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
            }
            .buttonStyle(PlainButtonStyle())
            
            /// Добавление удобрения.
            Button {
                showEditor = .addFertilizer
                
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.black)
                    .padding(10)
                    .background(.white)
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
    }
}

struct FertilizerView_Previews: PreviewProvider {
    static var previews: some View {
        FertilizerView()
    }
}

enum EditOrAdd: String {
    case addFertilizer  = "addFertilizer"
    case editFertilizer = "editFertilizer"
    case none           = "none"
}
