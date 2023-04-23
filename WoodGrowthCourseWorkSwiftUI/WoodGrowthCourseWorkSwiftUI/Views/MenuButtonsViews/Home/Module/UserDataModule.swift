//
//  UserDataModule.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 11.04.2023.
//

import Foundation
import SwiftUICharts
import SwiftUI

class UserData: ObservableObject {
    @Published var userData = UserResult(id: 0, login: "test", password: "test", photo: URL(string: "https://img3.goodfon.ru/wallpaper/nbig/7/fa/oboi-anime-devushki-miku-3104.jpg")!, firstname: "Дмитрий", lastname: "Пермяков", post: "Тестировщик")
    @Published var status  = false
    @Published var isAdmin = false
}

class ReportData: ObservableObject {
    @Published var trees            : [(String, Int)] = []
    @Published var percentOfGeneral : [(String, Double)] = []
    @Published var prices           : [([Double], GradientColor)] = []
    @Published var avgVolume        : [Double] = []
    @Published var totalVolume      = 0.0
    @Published var status           = (false, false, false)
    
    init() {
        refresh()
    }
    
    func refresh() {
        ReportsAPI.shared.countOfTreeInPlot { data, error in
            guard let data = data else {
                print("== ERROR FROM UserDataModule:", error!)
                DispatchQueue.main.async {
                    self.status.0 = false
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
                self.status.0 = true
                self.totalVolume = totalVolume
                self.percentOfGeneral = tempPercent
            }
        }
        
        ReportsAPI.shared.avgVolumeByDays { data, error in
            guard let data = data else {
                print("== ERROR FROM UserDataModule:", error!)
                DispatchQueue.main.async {
                    self.status.1 = false
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
                self.status.1 = true
            }
            
        }
        
        ReportsAPI.shared.prices { data, error in
            guard let data = data else {
                print("== ERROR FROM UserDataModule:", error!)
                DispatchQueue.main.async {
                    self.status.2 = false
                }
                return
            }

            let uniqueData = Set(data.rows.map { $0.fertilizer_id })
            var gradientColors = [
                GradientColors.orange,
                GradientColors.blue,
                GradientColors.blu,
                GradientColors.purple,
                GradientColors.prplPink,
                GradientColors.green,
                GradientColors.bluPurpl,
                GradientColors.orngPink,
                GradientColors.prplNeon
            ]
            
            var arrayOfPrices = [[Double]]()
            for el in uniqueData {
                var tempPrices = [Double]()
                for el2 in data.rows {
                    if el == el2.fertilizer_id {
                        tempPrices.append(Double(el2.price_order))
                    }
                }
                arrayOfPrices.append(tempPrices)
            }
            
            var resultTemp = [([Double], GradientColor)]()
            for el in arrayOfPrices {
                if let gradient = gradientColors.popLast() {
                    resultTemp.append((el, gradient))
                } else {
                    break
                }
            }
            
            DispatchQueue.main.async {
                self.prices = resultTemp
                self.status.2 = true
            }
        }
    }
    
}

/*
 var colors = [
     Color(hexString: "#E2FAE7"),
     Color(hexString: "#72BF82"),
     Color(hexString: "#EEF1FF"),
     Color(hexString: "#4266E8"),
     Color(hexString: "#FCECEA"),
     Color(hexString: "#E1614C"),
     Color(hexString: "#FF782C"),
     Color(hexString: "#EC2301"),
     Color(hexString: "#A7A6A8"),
     Color(hexString: "#E8E7EA"),
     Color(hexString: "#545454"),
     Color(hexString: "#FF57A6"),
     Color(hexString: "#C2E8FF"),
     Color(hexString: "#A8E1FF"),
     Color(hexString: "#7B75FF"),
     Color(hexString: "#6FEAFF"),
     Color(hexString: "#F1F9FF"),
     Color(hexString: "#1B205E"),
     Color(hexString: "#4EBCFF")
 ]
 */
