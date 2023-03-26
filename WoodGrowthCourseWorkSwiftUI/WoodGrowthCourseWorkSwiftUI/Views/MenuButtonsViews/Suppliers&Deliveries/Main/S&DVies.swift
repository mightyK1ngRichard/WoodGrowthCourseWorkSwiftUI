//
//  S&DVies.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import SwiftUI

struct S_DViews: View {
    @State private var pressedSupplierCard = false
    @State private var currentCardSupplier : SupplierResult?
    @ObservedObject var supplierData       = SupplierData()
    @ObservedObject var deliveryData       = DeliveryData()
    
    
    var body: some View {
        GeometryReader { _ in
            ZStack {
                VStack {
                    // Поставщики.
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(supplierData.supplierData) { card in
                                SupplierCard(pressedCard: $pressedSupplierCard, currentCard: $currentCardSupplier, data: card)
                                    .padding()
                                
                            }
                        }
                    }
                    Text("История поставок")
                        .padding(.horizontal, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 40))
                    
                    ScrollView {
                        ForEach(deliveryData.deliveryData) { item in
                            HStack {
                                Text(correctDate(dateString: "\(item.dateDelivery)"))
                                    .frame(width: 75)
                                Divider()
                                Text("\(item.numbersPackets)")
                                    .frame(width: 40)
                                Divider()
                                Text("\(item.priceOrder)")
                                    .frame(width: 100)
                                Divider()
                                Text(item.supplierName)
                                    .frame(width: 200)
                                Divider()
                                Text(item.fertilizerName)
                                    .frame(width: 100)
                            }
                            Divider()
                        }
                        .frame(width: 600)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                }
                
                if pressedSupplierCard {
                    Rectangle()
                        .foregroundColor(Color(red: 35/255, green: 36/255, blue: 76/255).opacity(0.7))
                        .onTapGesture {
                            pressedSupplierCard = false
                        }
                    
                    SupplierDetail(currentData: $currentCardSupplier, close: $pressedSupplierCard)

                }
            }
        }
    }
}

struct S_DVies_Previews: PreviewProvider {
    static var previews: some View {
        S_DViews()
    }
}
