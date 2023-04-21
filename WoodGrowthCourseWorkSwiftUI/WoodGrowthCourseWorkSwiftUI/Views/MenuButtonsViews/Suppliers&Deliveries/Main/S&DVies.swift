//
//  S&DVies.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import SwiftUI

struct S_DViews: View {
    @ObservedObject var supplierData       = SupplierData()
    @ObservedObject var deliveryData       = DeliveryData()
    @State private var currentCardSupplier : SupplierResult?
    @State private var pressedSupplierCard = false
    @State private var addSupplier         = false
    @State private var addDelivery         = false
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                MainView
                
                if pressedSupplierCard {
                    /// Редактирование информации по поставщику.
                    Rectangle()
                        .foregroundColor(getTabBackground().opacity(0.2))
                        .onTapGesture {
                            self.pressedSupplierCard = false
                        }
                    
                    SupplierDetail(currentData: $currentCardSupplier, close: $pressedSupplierCard)
                } else if addSupplier {
                    /// Добавления поставщика
                    Rectangle()
                        .foregroundColor(getTabBackground().opacity(0.2))
                        .onTapGesture {
                            self.addSupplier = false
                        }
                    AddendumSupplier(close: $addSupplier)
                } else if addDelivery {
                    Rectangle()
                        .foregroundColor(getTabBackground().opacity(0.2))
                        .onTapGesture {
                            self.addDelivery = false
                        }
                    AddendumDelivery(close: $addDelivery)
                }
            }
        }
        .environmentObject(supplierData)
        .environmentObject(deliveryData)
    }
    
    private var MainView: some View {
        VStack {
            if !supplierData.status || !deliveryData.status {
                TurnOffServer()
                
            } else {
                VStack {
                    supplierView()
                    deliveryView()
                }
            }
        }
    }
    
    private func supplierView() -> some View {
        VStack {
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(supplierData.supplierData) { card in
                        SupplierCard(pressedCard: $pressedSupplierCard, currentCard: $currentCardSupplier, data: card)
                    }
                }
            }
        }
    }
    
    private func deliveryView() -> some View {
        VStack {
            HStack {
                Text("История поставок")
                    .padding(.horizontal, 25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 40))
                
                Spacer()
                
                /// Добавление поставщика.
                Button {
                    self.addSupplier = true
                    
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(.white)
                        .cornerRadius(10)
                        .offset(y: 5)
                        .padding(.trailing, 5)
                }
                .buttonStyle(.plain)
                
                /// Добавление поставки.
                Button {
                    self.addDelivery = true
                    
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 35, height: 35)
                            .cornerRadius(10)
                        Image(systemName: "cart.fill.badge.plus")
                            .foregroundColor(.black)
                    }
                    .offset(y: 5)
                }
                .buttonStyle(.plain)
            }
            .padding(.trailing)
            
            ScrollView {
                ForEach(deliveryData.deliveryData) { item in
                    ItemOfTable(item: item)
                    Divider()
                }
                .frame(width: 725)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 20)
        }
    }
    
    
}
struct S_DVies_Previews: PreviewProvider {
    static var previews: some View {
        S_DViews()
    }
}
