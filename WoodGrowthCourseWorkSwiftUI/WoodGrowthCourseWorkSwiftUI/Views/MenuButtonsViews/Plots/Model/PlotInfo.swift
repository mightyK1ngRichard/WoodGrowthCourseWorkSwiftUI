//
//  PlotInfo.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import Foundation

class plotsCardsViewModel: ObservableObject {
    @Published var plotInfo: [PlotResult] = []
    @Published var status                 = true
    
    init() {
        refresh()
    }
    
    func refresh() {
        APIManager.shared.getPlots { data, error in
            guard let data = data else {
                print("== ERROR: ", error!)
                self.status = false
                return
            }
            self.status = true
            var temp: [PlotResult] = []
            for el in data.rows {
                let newEmployeer = PlotResult(id: el.plot_id, name: el.name_plot, date: el.date_planting, address: el.address, employee: el.full_name, emp_photo: el.photo, type_tree: el.name_type, fertilizerName: el.name, countTrees: el.counttrees, employerID: el.employer_id, typeTreeID: el.type_tree_id, typephoto: el.typephoto)
                temp.append(newEmployeer)
            }
            self.plotInfo = temp
        }
    }
    
}
