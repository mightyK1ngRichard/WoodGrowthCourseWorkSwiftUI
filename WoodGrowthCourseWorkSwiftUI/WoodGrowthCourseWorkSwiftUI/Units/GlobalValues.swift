//
//  GlobalValues.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 19.04.2023.
//

import Foundation

func correctDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date = dateFormatter.date(from: dateString)

    dateFormatter.dateFormat = "dd-MM-yyyy   HH:mm"
    let result = dateFormatter.string(from: date!)
    return result
}

func dateDifference(dateString: String?) -> String {
    guard let dateString1 = dateString else { return "" }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: dateString1) else { return "" }
    let currentDate = Date()
    let timeInterval = currentDate.timeIntervalSince(date)
    let days = Int(timeInterval / 86400)
    return "\(days)"
}

func correctDateWithTime(_ dateTime: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    let date = dateFormatter.date(from: "\(dateTime)")!
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return dateFormatter.string(from: date)
}

func getCorrectPhone(phoneString: String) -> String? {
    if  phoneString.count != 11 && phoneString.count != 12 {
        return nil
    }
    
    // Удалить первую цифру "8"
    let digits = phoneString.dropFirst()

    // Создать форматированную строку
    let formattedString = String(format: "8(%@) %@-%@-%@",
                                 digits.prefix(3) as CVarArg,                // первые три цифры после "8"
                                 digits.dropFirst(3).prefix(3) as CVarArg,   // следующие три цифры
                                 digits.dropFirst(6).prefix(2) as CVarArg,   // две цифры после первого дефиса
                                 digits.dropFirst(8).prefix(2) as CVarArg    // две цифры после второго дефиса
    )
    return formattedString
}

class PasswordForEnter {
    static let password = "430133"
}
