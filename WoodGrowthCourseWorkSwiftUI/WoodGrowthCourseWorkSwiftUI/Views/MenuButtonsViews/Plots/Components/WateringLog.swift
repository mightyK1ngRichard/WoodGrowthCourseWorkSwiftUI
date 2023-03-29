//
//  WateringLog.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 29.03.2023.
//

import SwiftUI

struct WateringLog: View {
    @State var isHover        = false
    @Binding var pressedClose : Bool
    var wateringLog           : [String]
    
    var body: some View {
        VStack (alignment: .leading) {
            ZStack {
                Text("История поливки:")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Image(systemName: "x.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.trailing, 5)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(isHover ? .red : .white)
                    .onTapGesture {
                         pressedClose = false
                    }
                    .onHover { hovering in
                        isHover = hovering
                    }
            }

            ScrollView {
                ForEach(wateringLog, id: \.self) { item in
                    VStack {
                        Text(correctDate(dateString: item))
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    }
                }
            }
        }
        .frame(width: 500, height: 332)
        .cornerRadius(10)
        .background(.black.opacity(0.8))
    }
}

struct WateringLog_Previews: PreviewProvider {
    static var previews: some View {
        WateringLog(pressedClose: .constant(true), wateringLog: [
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z",
            "2023-02-19T21:00:00.000Z"
        ])
    }
}
