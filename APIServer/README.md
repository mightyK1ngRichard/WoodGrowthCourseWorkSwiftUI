# Стыдно.

Назвать это сервером - язык не повернётся. Это просто недо API, которая принимает сырые SQL запросы и возращает JSON.

PS. По итогу, после сдачи курсовой, получилось разобраться с либой. Вот пример:

### Пример APIManager.
```swift
class APIManager {
    static let shared      = APIManager()
    private let host       = "127.0.0.1"
    private let database   = "<имя>"
    private let user       = "postgres"
    private let port       = 8080
    private let password   = Credential.scramSHA256(password: "<ПАРОЛЬ>")
    private let ssl        = false
    private var error      = false
    
    func getTrees() -> [Trees] {
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = self.host
            configuration.database = self.database
            configuration.user = self.user
            configuration.port = self.port
            configuration.credential = self.password
            configuration.ssl = self.ssl
            let connection = try! PostgresClientKit.Connection(configuration: configuration)
            defer { connection.close() }
            let text = """
            SELECT tree.tree_id, tt.type_id, tree.name_tree, tree.volume, tree.date_measurements, tree.notes, tt.name_type, p.name_plot, c.x_begin, c.x_end, c.y_begin, c.y_end, tt.photo
            FROM tree
            LEFT JOIN type_tree tt ON tree.type_tree_id=tt.type_id
            LEFT JOIN plot p ON p.type_tree_id=tt.type_id
            JOIN coordinates c ON c.tree_id=tree.tree_id;
            """
            let statement = try connection.prepareStatement(text: text)
            defer { statement.close() }
            let cursor = try statement.execute()
            defer { cursor.close() }
            
            var temp = [Trees]()
            for row in cursor {
                let columns        = try row.get().columns
                let id             = try columns[0].int()
                let typeID         = try columns[1].int()
                let nameTree       = try columns[2].string()
                let volume         = try columns[3].int()
                let dateMesurement = try columns[4].date()
                let notes          = try columns[5].optionalString()
                let nameType       = try columns[6].string()
                let namePlot       = try columns[7].optionalString()
                let xBegin         = try columns[8].int()
                let xEnd           = try columns[9].int()
                let yBegin         = try columns[10].int()
                let yEnd           = try columns[11].int()
                let photo          = try columns[12].string()
                
                guard let photo = URL(string: photo) else { return [Trees]() }
                temp.append(Trees(id: id, nameTree: nameTree, volume: volume, dateMesurement: toDate(postgresDate: dateMesurement) ?? Date(), notes: notes, typeID: typeID, nameType: nameType, namePlot: namePlot, xBegin: xBegin, xEnd: xEnd, yBegin: yBegin, yEnd: yEnd, photo: photo))
            }
            return temp
            
        } catch {
            print("==> ERROR FROM Network:", error)
            return [Trees]()
        }
    }
}
```

### Пример View.
```swift
  struct ContentView: View {
    @State private var trees        = [Trees]()
    @State private var textInSearch = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TreeView(trees: trees)
                NavigationLink(destination: SecondView(), label: {
                    Text("Welcome")
                })
            }
            .navigationTitle("Деревья")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
   
    private func TreeView(trees: [Trees]) -> some View {
        VStack {
            TextField("Поиск", text: $textInSearch)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.gray.opacity(0.2))
                .cornerRadius(15)
                .padding(.bottom)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(trees) { tree in
                        TypeTree(tree: tree)
                            
                    }
                }
            }
            Spacer()
        
        }
        .padding()
        .onAppear() {
            self.trees = APIManager.shared.getTrees()
        }
    }
}
```