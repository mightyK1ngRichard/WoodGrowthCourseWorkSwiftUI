//
//  githubProject.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 18.04.2023.
//

import SwiftUI

import SwiftUI
import SwiftUICharts


struct githubProject: View {
    var body: some View {
        ScrollView {
            VStack {
                
//                LineView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full screen")
//                    .padding()
                HStack {
                    LineChartView(data: [8,23,54,32,12,37,7,23,43], title: "Line chart", legend: "Full chart")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    
                    MultiLineChartView(data: [([8,32,11,23,40,28], GradientColors.green), ([90,99,78,111,70,60,77], GradientColors.purple), ([34,56,72,38,43,100,50], GradientColors.orngPink)], title: "Title")
                }
                .frame(width: 1000)
                .padding()
                            
                HStack {
                    BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Sales", legend: "Quarterly")
                    
                    BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", legend: "Legendary")
                }
                .padding()
                HStack {
                    BarChartView(data: ChartData(points: [8,23,54,32,12,37,7,23,43]), title: "Title", form: ChartForm.small)
                }
               
            }
            
        }
    }
}

struct githubProject_Previews: PreviewProvider {
    static var previews: some View {
        githubProject()
    }
}
