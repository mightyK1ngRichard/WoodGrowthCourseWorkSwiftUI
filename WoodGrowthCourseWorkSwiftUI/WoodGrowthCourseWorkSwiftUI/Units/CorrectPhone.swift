//
//  CorrectPhone.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 21.03.2023.
//

import Foundation

func getCorrectPhone(phoneString: String) -> String? {
    if  phoneString.count != 11 && phoneString.count != 12 {
        return nil
    }
    
    let digits = phoneString.dropFirst()
    
    let formattedString = String(format: "8(%@) %@-%@-%@",
                                 digits.prefix(3) as CVarArg,   // первые три цифры после "8"
                                 digits.dropFirst(3).prefix(3) as CVarArg,   // следующие три цифры
                                 digits.dropFirst(6).prefix(2) as CVarArg,   // две цифры после первого дефиса
                                 digits.dropFirst(8).prefix(2) as CVarArg    // две цифры после второго дефиса
    )
    return formattedString
}
