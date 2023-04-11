# АИС прироста древесины на различных участках.
<img src="https://img.shields.io/github/license/mightyK1ngRichard/IU5?color=brightgreen" alt="MIT License"/> <img src="https://img.shields.io/badge/language-SwiftUI-red.svg"/> <img src="https://img.shields.io/badge/language-postgresql-blue.svg"/>

🎓 BMSTU Course work

Курсовая работа по дисциплине "Базы данных" МГТУ им. Н.Э.Баумана 2023г.

## Про работу. 
Desktop app. В основе Framework'a лежит SwifUI.
БДшка - postgresql. Коммуникация [nodejs](https://github.com/mightyK1ngRichard/APIServer) сервака с Swift осуществляется по APIшке.
Дальнейшая бизнеслогика планируется на Джанго, если получится подружить их со Swift.

## Иерархия:
```swift
.
├── WoodGrowthCourseWorkSwiftUI
│   ├── APIModel
│   │   └── APIManager.swift
│   ├── ContentView.swift
│   ├── Preview Content
│   │   └── Preview Assets.xcassets
│   │       └── Contents.json
│   ├── Units
│   │   ├── CorrectPhone.swift
│   │   └── correctDate.swift
│   ├── Views
│   │   ├── HelpViews
│   │   │   ├── BlurWindow.swift
│   │   │   ├── SideBar.swift
│   │   │   ├── TabButton.swift
│   │   │   └── TurnOffServer.swift
│   │   └── MenuButtonsViews
│   │       ├── AdminMenuView.swift
│   │       ├── Authorization
│   │       │   └── Authorization.swift
│   │       ├── Employees
│   │       │   ├── Components
│   │       │   │   ├── DetailCard.swift
│   │       │   │   └── ScrollViewCard.swift
│   │       │   ├── Main
│   │       │   │   └── Employees.swift
│   │       │   └── Model
│   │       │       └── CardsEmployes.swift
│   │       ├── Fertilizers
│   │       │   ├── Components
│   │       │   │   ├── FertilizerCard.swift
│   │       │   │   └── FertilizerEdit.swift
│   │       │   ├── Main
│   │       │   │   └── FertilizerView.swift
│   │       │   └── Model
│   │       │       └── FertilizerData.swift
│   │       ├── Home
│   │       │   └── Home.swift
│   │       ├── Plots
│   │       │   ├── Components
│   │       │   │   ├── EditPlot.swift
│   │       │   │   ├── PlotCard.swift
│   │       │   │   └── WateringLog.swift
│   │       │   ├── Main
│   │       │   │   └── Plots.swift
│   │       │   └── Model
│   │       │       └── PlotInfo.swift
│   │       ├── Suppliers&Deliveries
│   │       │   ├── Deliveries
│   │       │   │   └── Modul
│   │       │   │       └── DeliveryData.swift
│   │       │   ├── Main
│   │       │   │   └── S&DVies.swift
│   │       │   └── Suppliers
│   │       │       ├── Component
│   │       │       │   ├── SupplierCard.swift
│   │       │       │   └── SupplierDetail.swift
│   │       │       └── Modul
│   │       │           └── SupplierData.swift
│   │       ├── Trees
│   │       │   ├── Components
│   │       │   │   ├── DetailCardTree.swift
│   │       │   │   └── TreeCard.swift
│   │       │   ├── Main
│   │       │   │   └── Trees.swift
│   │       │   └── Model
│   │       │       └── CardsTrees.swift
│   │       └── TypeTree
│   │           ├── Component
│   │           │   ├── TreeCardForTypeTreeView.swift
│   │           │   └── TypeTreeCard.swift
│   │           ├── Main
│   │           │   └── TypeTrees.swift
│   │           └── Module
│   │               └── TypeTreesModul.swift
│   ├── WoodGrowthCourseWorkSwiftUI.entitlements
│   └── WoodGrowthCourseWorkSwiftUIApp.swift
└── WoodGrowthCourseWorkSwiftUI.xcodeproj
    ├── project.pbxproj
    ├── project.xcworkspace
    │   ├── contents.xcworkspacedata
    │   ├── xcshareddata
    │   │   ├── IDEWorkspaceChecks.plist
    │   │   └── swiftpm
    │   │       ├── Package.resolved
    │   │       └── configuration
    │   └── xcuserdata
    │       └── dmitriy.xcuserdatad
    │           └── UserInterfaceState.xcuserstate
    └── xcuserdata
        └── dmitriy.xcuserdatad
            └── xcschemes
                └── xcschememanagement.plist

61 directories, 79 files
```
