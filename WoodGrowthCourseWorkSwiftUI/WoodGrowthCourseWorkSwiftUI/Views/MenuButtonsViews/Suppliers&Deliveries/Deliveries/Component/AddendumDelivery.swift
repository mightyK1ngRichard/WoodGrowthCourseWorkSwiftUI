//
//  AddendumDelivery.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 21.04.2023.
//

import SwiftUI

struct AddendumDelivery: View {
    @EnvironmentObject var deliveryData : DeliveryData
    @State private var allSupplier      : [SupplierResult] = []
    @State private var allFertilizer    : [AllFertilizerResult] = []
    @Binding var close                  : Bool
    @State private var dateDelivery     = Date()
    @State private var numberOfPackets  = ""
    @State private var price            = ""
    @State private var supplier         = ""
    @State private var fertilizer       = ""
    @State private var textInAlert      = ""
    @State private var isHover          = false
    @State private var showAlert        = false
    @State private var showScreen       = (false, false)
    
    var body: some View {
        ZStack {
            if showScreen.0 && showScreen.1 {
                MainView
                
            } else {
                ProgressView()
            }
            
        }
        .onAppear() {
            APIManager.shared.getAllFertilizer { data, error in
                guard let data = data else {
                    print("== ERROR FROM AddendumDelivery:", error!)
                    return
                }
                var tempData: [AllFertilizerResult] = []
                for el in data.rows {
                    let info = AllFertilizerResult(id: el.fertilizer_id, nameFertilizer: el.name)
                    tempData.append(info)
                }
                self.allFertilizer = tempData
                if self.allFertilizer.count != 0 {
                    self.fertilizer = self.allFertilizer[0].id
                    self.showScreen.0 = true
                    
                } else {
                    self.close = false
                }
            }
            
            APIManager.shared.getSupplier { data, error in
                guard let data = data else {
                    print("== ERROR FROM AddendumDelivery:", error!)
                    return
                }
                var tempData: [SupplierResult] = []
                for el in data.rows {
                    let info = SupplierResult(id: el.supplier_id, name_supplier: el.name_supplier, telephone: el.telephone, www: el.www, photo: el.photo)
                    tempData.append(info)
                }
                self.allSupplier = tempData
                if self.allSupplier.count != 0 {
                    self.supplier = self.allSupplier[0].id
                    self.showScreen.1 = true
                    
                } else {
                    self.close = false
                }
            }
        }
        .alert(textInAlert, isPresented: $showAlert) {}
    }
    
    private var closeView: some View {
        Image(systemName: "x.circle")
            .onHover { hovering in
                self.isHover = hovering
            }
            .onTapGesture {
                self.close = false
            }
            .foregroundColor(isHover ? .yellow : .white)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var MainView: some View {
        VStack {
            closeView
            Text("Добавление поставки:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
                .padding(.vertical)
            
            HStack {
                Picker("Поставщик", selection: $supplier) {
                    ForEach(allSupplier) {
                        Text($0.name_supplier)
                    }
                }
                Picker("Удобрение", selection: $fertilizer) {
                    ForEach(allFertilizer) {
                        Text($0.nameFertilizer)
                    }
                }
            }
            .padding(.bottom)
            
            HStack {
                MyTextField(textForUser: "Количество пакетов удобрений", text: $numberOfPackets)
                MyTextField(textForUser: "Итоговая цена", text: $price)
            }
            .padding(.bottom)
            
            DatePicker("Дата поставки", selection: $dateDelivery, in: ...Date())
            
            Button(action: {
                if numberOfPackets == "" || price == "" {
                    self.textInAlert = "Заполните число пакетов и цену!"
                    self.showAlert = true
                    return
                }
                
                let sqlString = """
                INSERT INTO delivery (date_delivery, numbers_packets, price_order, supplier_id, fertilizer_id)
                VALUES ('\(correctDateWithTime(dateDelivery))', '\(numberOfPackets)', '\(price)', '\(supplier)', '\(fertilizer)');
                """
                pullData(SQLQuery: sqlString)
                
            }, label: {
                Text("Добавить")
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                    .background(.black.opacity(0.3))
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20).stroke(Color(hexString: "#EC2301"), lineWidth: 1)
                    }
            })
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(.black)
        .frame(width: 500)
        .cornerRadius(20)
        .shadow(color: Color(red: 176/255, green: 0, blue: 0), radius: 10)
    }
    
    private func pullData(SQLQuery: String) {
        APIManager.shared.updateWithSlash(SQLQuery: SQLQuery) { resp, error in
            guard let _ = resp else {
                DispatchQueue.main.async {
                    self.deliveryData.refresh()
                    self.close = false
                }
                return
            }
            DispatchQueue.main.async {
                self.textInAlert = "Не получилось добавить поставку."
                self.showAlert = true
            }
            
        }
    }
}

struct AddendumDelivery_Previews: PreviewProvider {
    static var previews: some View {
        AddendumDelivery(close: .constant(false))
    }
}
