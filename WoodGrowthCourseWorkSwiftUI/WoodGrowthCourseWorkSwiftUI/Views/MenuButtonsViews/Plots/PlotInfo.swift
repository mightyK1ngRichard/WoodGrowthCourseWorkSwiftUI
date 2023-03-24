//
//  PlotInfo.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import Foundation

class plotsCardsViewModel: ObservableObject {
    @Published var plotInfo: [PlotResult] = []
    
    init() {
        APIManager.shared.getPlots { data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                return
            }
            for el in data.rows {
                let newEmployeer = PlotResult(id: el.plot_id, name: el.name_plot, date: el.date_planting, address: el.address, employee: el.full_name, emp_photo: el.photo, type_tree: el.name_type)
                self.plotInfo.append(newEmployeer)
            }
        }
    }
    
}
