//
//  DetailCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 21.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DetailCard: View {
    var currentPersonInfo: EmpoyeeResult?
    var body: some View {
        VStack(alignment: .center) {
            GeometryReader { reader in
                ScrollView {
                    if let image = currentPersonInfo?.ava {
                        WebImage(url: image)
                            .resizable()
                            .frame(width: 300, height: 300)
                            .padding(.top, 0)
                    } else {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                    }
                    Text("\(currentPersonInfo?.fullName ?? "Имя не найдено")")
                        .padding(0)
                        .font(.title)
                        .bold()
                    Text("\(currentPersonInfo?.post ?? "Должность не указана")")
                    Spacer()
                    if let phone = currentPersonInfo?.phone {
                        Text((getCorrectPhone(phoneString: phone) ?? "Телефон некорректный"))
                    } else {
                        Text("Телефон отсутствует")
                    }
                    Spacer()
                }
            }
            
        }
        .frame(minWidth: 300, maxWidth: 300, minHeight: 380, maxHeight: 380)
        .background(Color.white.opacity(0.5))
    }
}

struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(currentPersonInfo: nil)
    }
}
