//
//  UserDataModule.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 11.04.2023.
//

import Foundation

class UserData: ObservableObject {
    @Published var userData = UserResult(id: 0, login: "test", password: "test", photo: URL(string: "https://img3.goodfon.ru/wallpaper/nbig/7/fa/oboi-anime-devushki-miku-3104.jpg")!, firstname: "Дмитрий", lastname: "Пермяков", post: "Тестировщик")
    @Published var status = false
}

class ReportData: ObservableObject {
    @Published var trees            : [(String, Int)] = []
    @Published var percentOfGeneral : [(String, Double)] = []
    @Published var avgVolume        : [Double] = []
    @Published var totalVolume      = 0.0
    @Published var status           = false
    
    init() {
        refresh()
    }
    
    func refresh() {
        ReportsAPI.shared.countOfTreeInPlot { data, error in
            guard let data = data else {
                print("== ERROR FROM UserDataModule:", error!)
                DispatchQueue.main.async {
                    self.status = false
                }
                return
            }
            var tempData    : [(String, Int)] = []
            var tempPercent : [(String, Double)] = []
            let totalVolume = data.rows.reduce(0) { $0 + (Double($1.score_volum) ?? 0)}
            for el in data.rows {
                tempData.append(("Участок " + el.name_plot, Int(el.count_trees) ?? 0))
                /// Данный формата (Участок, процент объёма от всего объёма на участке)
                let num = Double(el.score_volum) ?? 0
                tempPercent.append((el.name_plot, (num / totalVolume) * 100))
            }
            
            DispatchQueue.main.async {
                self.trees = tempData
                self.status = true
                self.totalVolume = totalVolume
                self.percentOfGeneral = tempPercent
            }
        }
        
        ReportsAPI.shared.avgVolumeByDays { data, error in
            guard let data = data else {
                print("== ERROR FROM UserDataModule:", error!)
                DispatchQueue.main.async {
                    self.status = false
                }
                return
            }
            var tempData: [Double] = []
            for el in data.rows {
                if let number = Double(el.avg) {
                    tempData.append(number)
                }
            }
            
            DispatchQueue.main.async {
                self.avgVolume = tempData
                self.status = true
            }
            
        }
    }
    
}

