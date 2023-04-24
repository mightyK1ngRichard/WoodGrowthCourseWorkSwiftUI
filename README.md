# АИС прироста древесины на различных участках.
<img src="https://img.shields.io/github/license/mightyK1ngRichard/IU5?color=brightgreen" alt="MIT License"/> <img src="https://img.shields.io/badge/language-SwiftUI-red.svg"/> <img src="https://img.shields.io/badge/language-Postgresql-blue.svg"/> <img src="https://img.shields.io/badge/language-NodeJS-yellow.svg"/>

🎓 BMSTU Course work

Курсовая работа по дисциплине "Базы данных" МГТУ им. Н.Э.Баумана 2023г.

## Про работу. 
Desktop app. В основе Framework'a лежит SwifUI.
БДшка - postgresql. Коммуникация [nodejs](https://github.com/mightyK1ngRichard/APIServer) сервака с Swift осуществляется по API.

## Иерархия проекта:
<details>
  <summary> Click to expand </summary>

```swift
.
├── Wood Business.xcodeproj
│   ├── project.pbxproj
│   ├── project.xcworkspace
│   │   ├── contents.xcworkspacedata
│   │   ├── xcshareddata
│   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   └── swiftpm
│   │   │       ├── Package.resolved
│   │   │       └── configuration
│   │   └── xcuserdata
│   │       └── dmitriy.xcuserdatad
│   │           └── UserInterfaceState.xcuserstate
│   ├── xcshareddata
│   │   └── xcschemes
│   │       └── WoodGrowthCourseWorkSwiftUI.xcscheme
│   └── xcuserdata
│       └── dmitriy.xcuserdatad
│           └── xcdebugger
│               └── Breakpoints_v2.xcbkptlist
└── WoodGrowthCourseWorkSwiftUI
    ├── ContentView.swift
    ├── Fonts
    ├── Network
    │   ├── APIManager.swift
    │   └── ReportsAPI.swift
    ├── Preview Content
    │   └── Preview Assets.xcassets
    │       └── Contents.json
    ├── Units
    │   ├── GlobalValues.swift
    │   └── WoodGrowthCourseWorkSwiftUI 2023-04-19 20-16-56
    │       └── WoodGrowthCourseWorkSwiftUI.app
    │           └── Contents
    │               ├── Info.plist
    │               ├── MacOS
    │               │   └── WoodGrowthCourseWorkSwiftUI
    │               ├── PkgInfo
    │               ├── Resources
    │               │   ├── AppIcon.icns
    │               │   └── Assets.car
    │               └── _CodeSignature
    │                   └── CodeResources
    ├── Views
    │   ├── HelpViews
    │   │   ├── BlurWindow.swift
    │   │   ├── SideBar.swift
    │   │   ├── TabButton.swift
    │   │   └── TurnOffServer.swift
    │   └── MenuButtonsViews
    │       ├── AdminMenuView.swift
    │       ├── Authorization
    │       │   └── Authorization.swift
    │       ├── Employees
    │       │   ├── Components
    │       │   │   ├── AddEmployee.swift
    │       │   │   ├── DetailCard.swift
    │       │   │   └── ScrollViewCard.swift
    │       │   ├── Main
    │       │   │   └── Employees.swift
    │       │   └── Model
    │       │       └── CardsEmployes.swift
    │       ├── Fertilizers
    │       │   ├── Components
    │       │   │   ├── AddendumFertilzer.swift
    │       │   │   ├── FertilizerCard.swift
    │       │   │   └── FertilizerEdit.swift
    │       │   ├── Main
    │       │   │   └── FertilizerView.swift
    │       │   └── Model
    │       │       └── FertilizerData.swift
    │       ├── Home
    │       │   ├── Component
    │       │   │   ├── Rings.swift
    │       │   │   └── githubProject.swift
    │       │   ├── Main
    │       │   │   └── Home.swift
    │       │   └── Module
    │       │       └── UserDataModule.swift
    │       ├── Plots
    │       │   ├── Components
    │       │   │   ├── AddendumCard.swift
    │       │   │   ├── EditPlot.swift
    │       │   │   ├── PlotCard.swift
    │       │   │   └── WateringLog.swift
    │       │   ├── Main
    │       │   │   └── Plots.swift
    │       │   └── Model
    │       │       └── PlotInfo.swift
    │       ├── Suppliers&Deliveries
    │       │   ├── Deliveries
    │       │   │   ├── Component
    │       │   │   │   ├── AddendumDelivery.swift
    │       │   │   │   └── ItemOfTable.swift
    │       │   │   └── Modul
    │       │   │       └── DeliveryData.swift
    │       │   ├── Main
    │       │   │   └── S&DVies.swift
    │       │   └── Suppliers
    │       │       ├── Component
    │       │       │   ├── AddendumSupplier.swift
    │       │       │   ├── SupplierCard.swift
    │       │       │   └── SupplierDetail.swift
    │       │       └── Modul
    │       │           └── SupplierData.swift
    │       ├── Trees
    │       │   ├── Components
    │       │   │   ├── DetailCardTree.swift
    │       │   │   └── TreeCard.swift
    │       │   ├── Main
    │       │   │   └── Trees.swift
    │       │   └── Model
    │       │       └── CardsTrees.swift
    │       └── TypeTree
    │           ├── Component
    │           │   ├── Buttons
    │           │   │   ├── AddTreeForType.swift
    │           │   │   ├── AddTypeTree.swift
    │           │   │   └── EditTypeTree.swift
    │           │   ├── TreeCardForTypeTreeView.swift
    │           │   └── TypeTreeCard.swift
    │           ├── Main
    │           │   └── TypeTrees.swift
    │           └── Module
    │               └── TypeTreesModul.swift
    ├── WoodGrowthCourseWorkSwiftUI.entitlements
    └── WoodGrowthCourseWorkSwiftUIApp.swift

69 directories, 88 files
```

</details>

## Установка.
[Сборка приложения](https://github.com/mightyK1ngRichard/WoodGrowthCourseWorkSwiftUI/tree/main/Wood%20Business)

### TODO: 
- [X] [Видеодемонстрация](https://drive.google.com/file/d/1Rsf4_2HhWkoXN4h2QfeLxxU3uppbb3a9/view?usp=share_link)
- [ ] [Гайд пользования]()
    