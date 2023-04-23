//
//  ItemOfTable.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.04.2023.
//

import SwiftUI

struct ItemOfTable: View {
    @EnvironmentObject var deliveryData : DeliveryData
    private let colors                  = [.black, Color(red: 176/255, green: 0, blue: 0)]
    @State private var isHover          = false
    @State private var showAlert        = false
    @State private var showAlertDelete  = false
    @State private var textInAlert      = ""
    @State private var inputPassword    = ""
    @State private var colorIndex       = 0
    var item                            : DeliveryResult
    
    var body: some View {
        HStack {
            Group {
                Text(correctDate(dateString: "\(item.dateDelivery)"))
                    .frame(width: 80)
                Divider()
                Text("\(item.numbersPackets)")
                    .frame(width: 40)
            }
            
            Group {
                Divider()
                Text("\(item.priceOrder)")
                    .frame(width: 100)
                Divider()
                Text(item.supplierName)
                    .frame(width: 200)
                Divider()
                Text(item.fertilizerName)
                    .frame(width: 200)
            }
            
            Button {
                self.showAlertDelete = true
                
            } label: {
                Image(systemName: "trash")
                    .onHover { hovering in
                        self.isHover = hovering
                    }
                    .foregroundColor(isHover ? Color(red: 176/255, green: 0, blue: 0) : colors[colorIndex % colors.count])
                    .padding(.leading)
            }
            .buttonStyle(.plain)
        }
        .onReceive(deliveryData.$status) { _ in
            /// Таймер для показа карзины. Т.е мы меняем ей цвет.
            let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
                withAnimation {
                    colorIndex += 1
                }
                if colorIndex == colors.count {
                    colorIndex = 0
                    timer.invalidate()
                }
            }
            timer.fire()
        }
        .alert("Удаление", isPresented: $showAlertDelete, actions: {
            SecureField("Пароль", text: $inputPassword)
            Button("Удалить") {
                if inputPassword == "\(PasswordForEnter.password)" {
                    let SQLQuery = """
                    DELETE FROM delivery WHERE delivery_id='\(item.id)';
                    """
                    APIManager.shared.generalUpdate(SQLQuery: SQLQuery) { data, error in
                        guard let _ = data else {
                            print("== ERROR FROM ItemOfTable func[alert]:", error!)
                            return
                        }
                        DispatchQueue.main.async {
                            self.deliveryData.refresh()
                        }
                    }
                }
            }
            Button("Отмена", role: .cancel, action: {})
            
        }, message: {
            Text("Введите пароль, чтобы подтвердить право на удаление.")
        })
    }
}

struct ItemOfTable_Previews: PreviewProvider {
    static var previews: some View {
        let default1 = DeliveryData()
        
        ItemOfTable(item: DeliveryResult(id: "0", dateDelivery: "2017-02-14T21:00:00.000Z", numbersPackets: 100, priceOrder: 100, supplierName: "Жесть", fertilizerName: "Жесть удобрение", supplierID: "0"))
            .environmentObject(default1)
    }
}
