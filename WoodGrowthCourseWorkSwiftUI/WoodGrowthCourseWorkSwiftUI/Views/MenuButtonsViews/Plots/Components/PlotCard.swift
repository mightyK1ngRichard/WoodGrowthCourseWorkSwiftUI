//
//  PlotCard.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 24.03.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlotCard: View {
    var plotInfo                        : PlotResult
    @State private var openEdit         = false
    @State private var isHovering       = false
    @State private var isShowCalendar   = false
    @State private var isShowTrash      = false
    @State private var isHoverOnImage   = false
    @State private var openLogWatering  = false
    @State private var dataLog          : [String] = []
    @State private var allEmployees     : [AllEmpoyeesResult] = []
    @State private var allFreeTypes     : [(String, String)] = []
    @State private var allFreeEmployees : [(String, String)] = []
    @State private var showAlert        = false
    @State private var alertText        = ""
    @EnvironmentObject var plotsData    : plotsCardsViewModel
    
    var body: some View {
        if openEdit {
            EditPlot(currentData: plotInfo, pressedClose: $openEdit, allTypesFree: allFreeTypes, allEmployeesFree: allFreeEmployees)
            
        } else {
            CardPreview()
        }

    }
    
    private func CardPreview() -> some View {
        ZStack(alignment: .top) {
            WebImage(url: plotInfo.typephoto)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .brightness(isHoverOnImage ? -0.1 : 0)
                .onHover { hovering in
                    isHoverOnImage = hovering
                }
            
            ImagesView()
            InfoAboutPlotView()
            NamePlotView()
            
            if openLogWatering {
                WateringLog(pressedClose: $openLogWatering, wateringLog: dataLog)
            }
        }
        .frame(width: 500, height: 330)
        .cornerRadius(15)
    }
    
    private func ImagesView() -> some View {
        HStack {
            // Кнопка удалить.
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .overlay {
                    Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isShowTrash ? .red : .black)
                }
                .opacity(isHoverOnImage ? (isShowTrash ? 1 : 0.7) : 0)
                .onHover { hovering in
                    isShowTrash = hovering
                }
                .onTapGesture {
                    showAlert = true
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.top, 10)
                .alert("Удаление", isPresented: $showAlert, actions: {
                    SecureField("Пароль", text: $alertText)
                    Button("Удалить", action: {
                        if alertText == "430133" {
                            let SQLQuery = "DELETE FROM plot WHERE plot_id='\(plotInfo.id)';"
                            APIManager.shared.generalUpdate(SQLQuery: SQLQuery) { data, error in
                                guard let _ = data else {
                                    print("== ERROR FROM ", error!)
                                    return
                                }
                                plotsData.refresh()
                                // ... Можно додумать что-то.
                            }
                        }
                    })
                    Button("Отмена", role: .cancel, action: {})
                    
                }, message: {
                    Text("Введите пароль, чтобы подтвердить право на удаление.")
                })
            
            // Кнопка календарь.
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .overlay {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.black)
                }
                .onHover { hovering in
                    isShowCalendar = hovering
                }
                .onTapGesture {
                    APIManager.shared.getWateringPlots(plotsID: plotInfo.id) { data, error in
                        guard let data = data else {
                            print("== ERROR", error!)
                            return
                        }
                        var tempData: [String] = []
                        for el in data.rows {
                            tempData.append(el.date_watering)
                        }
                        
                        DispatchQueue.main.async {
                            self.dataLog = tempData
                            self.openLogWatering = true
                        }
                    }
                }
                .opacity(isHoverOnImage ? (isShowCalendar ? 1 : 0.7) : 0)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
            .padding(.top, 10)
        }
    }
    
    private func NamePlotView() -> some View {
        Text(plotInfo.name)
            .onHover { hovering in
                self.isHovering = hovering
            }
            .onTapGesture {
                getFreeDate()
            }
            .padding(.horizontal, 46)
            .offset(y: -3)
            .font(.system(size: 70))
            .background(.black)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(getGradient(), lineWidth: 3)
            }
            .offset(y: 98)
            .foregroundColor(.white)
            .brightness(isHovering ? 0.4 : 0)
    }
    
    private func InfoAboutPlotView() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Дата заземления: ")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                Text(correctDate(dateString: plotInfo.date))
                Text("Удобрение: ")
                    .font(.title3)
                    .bold()
                + Text(plotInfo.fertilizerName ?? "Не задано")
                
                Text("**Вид:** ")
                    .font(.title3)
                + Text(plotInfo.type_tree)
                Text("Количество деревьев: ")
                    .font(.title3)
                    .bold()
                + Text(plotInfo.countTrees)
                
                Text("Адрес: ")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                
                Text(plotInfo.address)
                
                Spacer()
            }
            .foregroundColor(.black)
            .padding(.leading)
            
            Spacer()
            
            VStack (alignment: .center) {
                Text("Ответсвенный:")
                    .font(.title3)
                    .bold()
                    .padding(.top, 20)
                
                if let img = plotInfo.emp_photo {
                    WebImage(url: img)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                    
                } else {
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                }
                
                Text(plotInfo.employee)
                    .font(.title)
                    .bold()
            }
            .foregroundColor(.black)
            .padding(.horizontal, 20)
        }
        .background(.white)
        .offset(y: 144)
    }
    
    private func getFreeDate() {
        APIManager.shared.getAllEmpoyeesAndTypes { data, error in
            guard let data = data else {
                print("== ERROR FROM EditPlot:", error!)
                return
            }
            
            var tempTypes: [(String, String)] = [("\(plotInfo.typeTreeID)", plotInfo.type_tree)]
            var tempEmployees: [(String, String)] = [(plotInfo.employerID, plotInfo.employee)]

            for el in data.rows {
                if el.type_id == nil {
                    guard let t1 = el.employer_id, let t2 = el.full_name else {
                        print("== ERROR2 PlotCard. Невозможная ситуация, nil там, где его не может быть. Мб неверно заполнена БД. А именно для работника = \(el.employer_id ?? "Пусто"), или вида дерева \(String(describing: el.type_id))")
                        return }
                    
                    tempEmployees.append((t1, t2))
                }
                
                else if el.employer_id == nil {
                    guard let t1 = el.type_id, let t2 = el.name_type else {
                        print("== ERROR2 PlotCard. Невозможная ситуация, nil там, где его не может быть. Мб неверно заполнена БД. А именно для работника = \(el.employer_id ?? "Пусто"), или вида дерева \(String(describing: el.type_id))")
                        return
                    }
                    
                    tempTypes.append((t1, t2))
                }
            }
            
            DispatchQueue.main.async {
                self.allFreeTypes = tempTypes
                self.allFreeEmployees = tempEmployees
                self.openEdit.toggle()
            }
        }
    }
}

struct PlotCard_Previews: PreviewProvider {
    static var previews: some View {
        PlotCard(plotInfo: PlotResult(id: "0", name: "F", date: "s", address: "Ул. Далеко что жесть", employee: "Вова Степанов", emp_photo: nil, type_tree: "Берёза", fertilizerName: "Удобрение 1", countTrees: "23", employerID: "0", typeTreeID: 0, typephoto: URL(string: "https://phonoteka.org/uploads/posts/2021-05/1621391291_26-phonoteka_org-p-luntik-fon-27.jpg")!))
    }
}
