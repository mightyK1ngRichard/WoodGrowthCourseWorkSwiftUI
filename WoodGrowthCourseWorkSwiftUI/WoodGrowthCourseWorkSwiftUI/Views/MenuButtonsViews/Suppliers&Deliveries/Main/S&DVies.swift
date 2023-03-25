//
//  S&DVies.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 26.03.2023.
//

import SwiftUI

struct S_DViews: View {
    @ObservedObject var supplierData = SupplierData()
    
    var body: some View {
        GeometryReader { _ in
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(supplierData.supplierData) { card in
                        SupplierCard(data: card)
                            .padding()
                        
                    }
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
