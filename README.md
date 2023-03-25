# АИС прироста древесины на различных участках.
<img src="https://img.shields.io/github/license/mightyK1ngRichard/IU5?color=brightgreen" alt="MIT License"/> <img src="https://img.shields.io/badge/language-SwiftUI-red.svg"/> <img src="https://img.shields.io/badge/language-postgresql-blue.svg"/>

🎓 BMSTU Course work

Курсовая работа по дисциплине "Базы данных" МГТУ им. Н.Э.Баумана 2023г.

## Про работу. 
Desktop app. Вёрстка написана ручками на SwifUI.
В основе базы данных лежит postgresql. Работа с бд осуществляестя засчёт передачи информации по API через сервер, написанный на [js](https://github.com/mightyK1ngRichard/APIServer), так как проблематично работать с postgresql прямиком через swift.

## Previews:
<img class="authorization" src="https://github.com/mightyK1ngRichard/WoodGrowthCourseWorkSwiftUI/blob/main/Previews/Preview.png" width="1000"/>

## Иерархия:
```swift
├── WoodGrowthCourseWorkSwiftUI
│   ├── Assets.xcassets
│   │   ├── AccentColor.colorset
│   │   │   └── Contents.json
│   │   ├── AppIcon.appiconset
│   │   │   └── Contents.json
│   │   ├── Contents.json
│   │   ├── auth.imageset
│   │   │   ├── Contents.json
│   │   │   └── auth.jpeg
│   │   ├── background.imageset
│   │   │   ├── Contents.json
│   │   │   └── wallpaperflare.com_wallpaper.jpg
│   │   ├── logo.imageset
│   │   │   ├── Contents.json
│   │   │   └── logo.png
│   │   ├── money.imageset
│   │   │   ├── Contents.json
│   │   │   └── money.png
│   │   ├── turnoffserver.imageset
│   │   │   ├── Contents.json
│   │   │   └── RzxV0kCip7U.jpg
│   │   ├── Дуб.imageset
│   │   │   ├── Contents.json
│   │   │   └── Дуб.png
│   │   ├── Ель.imageset
│   │   │   ├── Contents.json
│   │   │   └── Ель.png
│   │   ├── Сосна.imageset
│   │   │   ├── Contents.json
│   │   │   └── Сосна.png
│   │   ├── Бамбук.imageset
│   │   │   ├── Contents.json
│   │   │   └── Бамбук.png
│   │   └── Берёза.imageset
│   │       ├── Contents.json
│   │       └── Берёза.jpg
│   ├── ContentView.swift
│   ├── Model
│   │   └── APIManager.swift
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
│   │       ├── Authorization.swift
│   │       ├── Deliveries.swift
│   │       ├── Employees
│   │       │   ├── CardsEmployes.swift
│   │       │   ├── DetailCard.swift
│   │       │   ├── Main
│   │       │   │   └── Employees.swift
│   │       │   └── ScrollViewCard.swift
│   │       ├── Home.swift
│   │       ├── Plots
│   │       │   ├── EditPlot.swift
│   │       │   ├── Main
│   │       │   │   └── Plots.swift
│   │       │   ├── PlotCard.swift
│   │       │   └── PlotInfo.swift
│   │       └── Trees
│   │           ├── CardsTrees.swift
│   │           ├── DetailCardTree.swift
│   │           ├── Main
│   │           │   └── Trees.swift
│   │           └── TreeCard.swift
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
            ├── xcdebugger
            │   └── Breakpoints_v2.xcbkptlist
            └── xcschemes
                └── xcschememanagement.plist

39 directories, 57 files
```
