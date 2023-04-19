//
//  FertilizerCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 25.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct FertilizerCard: View {
    @EnvironmentObject var allFertilizers : FertilizerData
    @Binding var isPressedCard            : EditOrAdd
    @State private var isHover            = false
    @State private var isHoverOnTrash     = false
    @State private var showAlert          = false
    @State private var showAlert2         = false
    @State private var textForAlert       = ""
    @State private var inputPassword      = ""
    var data                              : FertilizerResult
    
    var body: some View {
        MainView
    }
    
    private var MainView: some View {
        VStack {
            ImageTypeTree
            TextUnderImage
        }
        .padding()
        .background(getGradient().opacity(0.2))
        .cornerRadius(15)
        .brightness(isHover ? -0.2 : 0)
        .onHover { hovering in
            isHover = hovering
        }
        .onTapGesture {
            allFertilizers.currentCard = data
            isPressedCard = .editFertilizer
        }
        .alert(textForAlert, isPresented: $showAlert) { }
    }
    
    private var ImageTypeTree: some View {
        ZStack {
            if let typeTreeImage = data.photo {
                WebImage(url: typeTreeImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 200)
                    .cornerRadius(20)
                    .shadow(color: .yellow, radius: 5)
            } else {
                Image(systemName: "tree")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 200)
                    .cornerRadius(20)
                    .shadow(color: .yellow, radius: 5)
            }
            
            Image(systemName: "trash")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(5)
                .onHover() { hovering in
                    self.isHoverOnTrash = hovering
                }
                .background(isHover ? (isHoverOnTrash ? .white.opacity(1) : .white.opacity(0.5)) : .white.opacity(0))
                .cornerRadius(50)
                .offset(x: 124, y: -74)
                .foregroundColor(isHover ? (isHoverOnTrash ? .red : .black.opacity(1)) : .black.opacity(0))
                .onTapGesture {
                    textForAlert = "Что то про ошибку"
                    self.showAlert2 = true
                }
        }
        .alert("Удаление", isPresented: $showAlert2, actions: {
            SecureField("Пароль", text: $inputPassword)
            Button("Удалить") {
                if inputPassword == "\(PasswordForEnter.password)" {
                    let SQLQuery = "DELETE FROM fertilizer WHERE fertilizer_id=\(data.id);"
                    DeleteFertilizer(SQLString: SQLQuery)
                }
            }
            Button("Отмена", role: .cancel, action: {})
            
        }, message: {
            Text("Введите пароль, чтобы подтвердить право на удаление.")
        })
    }
    
    private var TextUnderImage: some View {
        VStack {
            Text(data.nameFertilizer.capitalized)
                .font(.system(size: 35))
                .bold()
                .padding(.bottom, 5)
                .offset(y: -13)
                .frame(width: 300)
                .lineLimit(1)
            
            VStack(spacing: 3) {
                Text("**Цена:** \(data.priceFertilizer) ₽")
                Text("**Масса:** \(data.massFertilizer) м³")
                Text("**Вид:** \(data.typeTree ?? "Нету")")
                Text("**Поставщик:** \(data.nameSupplier ?? "Нету")")
            }
            .font(.system(size: 16))
        }
    }
    
    private func DeleteFertilizer(SQLString: String) {
        APIManager.shared.generalUpdate(SQLQuery: SQLString) { data, error in
            guard let _ = data else {
                self.textForAlert = "Ошибка со стороны БД. Ну заплачь"
                self.showAlert = true
                print("== ERROR FROM FertilizerCard func[PressedDeleteFertilizer]:", error!)
                return
            }
            allFertilizers.refresh()
        }
    }
}

struct FertilizerCard_Previews: PreviewProvider {
    static var previews: some View {
        let testData = FertilizerResult(id: "1", nameFertilizer: "Удобрение", priceFertilizer: 1000, massFertilizer: 1000, typeTree: "Дуб", type_id: "1", nameSupplier: "Леруа Мерлен", photo: URL(string: "https://klike.net/uploads/posts/2023-01/1674189522_3-98.jpg")!)
        
        FertilizerCard(isPressedCard: .constant(.none), data: testData)

    }
}
