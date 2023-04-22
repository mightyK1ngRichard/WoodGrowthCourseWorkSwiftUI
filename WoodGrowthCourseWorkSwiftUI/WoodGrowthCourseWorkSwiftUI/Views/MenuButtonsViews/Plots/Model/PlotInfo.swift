//
//  PlotInfo.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import Foundation

class plotsCardsViewModel: ObservableObject {
    @Published var plotInfo: [PlotResult] = [
        PlotResult(id: "0", name: "А", date: "2017-02-14T21:00:00.000Z", address: "Ул.Легенда дом 10 кв.2", employee: "Стасян Красава", emp_photo: URL(string: "https://pibig.info/uploads/posts/2021-04/thumbs/1619453496_21-pibig_info-p-yegao-anime-krasivo-22.jpg")!, type_tree: "Берёза", fertilizerName: "IPhone 14 Pro Max", countTrees: "100", employerID: "1", typeTreeID: 1, typephoto: URL(string: "https://vsegda-pomnim.com/uploads/posts/2022-04/1649619470_19-vsegda-pomnim-com-p-palmi-foto-22.jpg")!, lastWatering: 57)
    ]
    @Published var status = true
    
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
                let newEmployeer = PlotResult(id: el.plot_id, name: el.name_plot, date: el.date_planting, address: el.address, employee: el.full_name, emp_photo: el.photo, type_tree: el.name_type, fertilizerName: el.name, countTrees: el.counttrees, employerID: el.employer_id, typeTreeID: el.type_tree_id, typephoto: el.typephoto, lastWatering: el.lastwatering)
                temp.append(newEmployeer)
            }
            self.plotInfo = temp
        }
    }
    
}
