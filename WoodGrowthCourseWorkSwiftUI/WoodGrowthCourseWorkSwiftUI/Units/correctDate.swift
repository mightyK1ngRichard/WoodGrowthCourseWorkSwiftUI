//
//  correctDate.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 22.03.2023.
//

import Foundation

func correctDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: dateString)

    dateFormatter.dateFormat = "yyyy-MM-dd"
    let result = dateFormatter.string(from: date!)
    return result
}
