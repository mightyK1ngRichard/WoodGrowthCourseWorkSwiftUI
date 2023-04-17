//
//  APIManager.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let host  = "localhost"
    private let port  = 8010
    
    // MARK: - Select.
    func getAllEmpoyeesAndTypes(completion: @escaping (AllEmployeesAndTypes?, String?) -> Void) {
        let SQLQuery = """
        SELECT e.employer_id, e.full_name, tt.type_id, tt.name_type
        FROM plot
        FULL JOIN employer e on plot.employer_id = e.employer_id
        FULL JOIN type_tree tt on plot.type_tree_id = tt.type_id
        WHERE e.employer_id is NULL or tt.type_id is NULL;
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }

                if let newInfo = try? JSONDecoder().decode(AllEmployeesAndTypes.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getEmployers(completion: @escaping (Employers?, String?) -> Void) {
        let SQLQuery = """
        SELECT e.employer_id, e.full_name, e.post, e.phone_number, e.photo, p.name_plot AS name_plot, tt.name_type AS name_type
        FROM employer e
        LEFT JOIN plot p on e.employer_id = p.employer_id
        LEFT JOIN type_tree tt on p.type_tree_id = tt.type_id;
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }

                if let newInfo = try? JSONDecoder().decode(Employers.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getTrees(typeID: String? = nil, completion: @escaping (TreesParse?, String?) -> Void) {
        var SQLQuery = """
        SELECT tree.tree_id, tree.name_tree, tree.volume, tree.date_measurements, tree.notes, tt.name_type, p.name_plot, c.x_begin, c.x_end, c.y_begin, c.y_end, tt.photo
        FROM tree
        LEFT JOIN type_tree tt ON tree.type_tree_id=tt.type_id
        LEFT JOIN plot p ON p.type_tree_id=tt.type_id
        JOIN coordinates c ON c.tree_id=tree.tree_id
        """
        if let typeID = typeID {
            SQLQuery += " WHERE tt.type_id=\(typeID);"
        }
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }
                if let newInfo = try? JSONDecoder().decode(TreesParse.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getPlots(completion: @escaping (PlotsParse?, String?) -> Void) {
        let SQLQuery = """
        SELECT p.plot_id, p.name_plot, p.date_planting, p.address, type_tree.name_type,
        employer.full_name, employer.photo, f.name, p.employer_id, p.type_tree_id, type_tree.photo AS typePhoto, COUNT(*) countTrees
        FROM tree
        FULL JOIN plot p ON p.type_tree_id=tree.type_tree_id
        LEFT JOIN employer ON p.employer_id=employer.employer_id
        LEFT JOIN type_tree ON p.type_tree_id=type_tree.type_id
        LEFT JOIN fertilizer f ON type_tree.type_id = f.type_tree_id
        WHERE p.plot_id IS NOT NULL
        GROUP BY p.plot_id, p.name_plot, p.date_planting, p.address, type_tree.name_type,
        employer.full_name, employer.photo, f.name, type_tree.type_id;
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }
                if let newInfo = try? JSONDecoder().decode(PlotsParse.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getFertilizer(completion: @escaping (FeritilizerParse?, String?) -> Void) {
        let SQLQuery = """
        SELECT fertilizer.fertilizer_id, fertilizer.name, fertilizer.price, fertilizer.mass,
        tt.name_type, s.name_supplier, tt.photo
        FROM fertilizer
        LEFT JOIN type_tree tt ON fertilizer.type_tree_id=tt.type_id
        JOIN delivery d on fertilizer.fertilizer_id = d.fertilizer_id
        JOIN supplier s on d.supplier_id = s.supplier_id;
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }
                if let newInfo = try? JSONDecoder().decode(FeritilizerParse.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getSupplier(completion: @escaping (SupplierParse?, String?) -> Void) {
        let SQLQuery = """
        select * from supplier;
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }
                if let newInfo = try? JSONDecoder().decode(SupplierParse.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getDeliveries(completion: @escaping (DeliveriesParse?, String?) -> Void) {
        let SQLQuery = """
        SELECT delivery.delivery_id, delivery.date_delivery, delivery.numbers_packets,
        delivery.price_order, supplier.name_supplier, fertilizer.name
        FROM delivery
        JOIN supplier ON supplier.supplier_id=delivery.supplier_id
        JOIN fertilizer ON fertilizer.fertilizer_id=delivery.fertilizer_id;
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }
                if let newInfo = try? JSONDecoder().decode(DeliveriesParse.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getWateringUser(userID: String, completion: @escaping (WateringEmployee?, String?) -> Void) {
        let SQLQuery = """
         select watering.date_watering as date_
         from watering
         join plot on plot.plot_id = watering.plot_id
         join employer on employer.employer_id = plot.employer_id
         where employer.employer_id = \(userID);
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }
                if let newInfo = try? JSONDecoder().decode(WateringEmployee.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getWateringPlots(plotsID: String, completion: @escaping (WateringPlots?, String?) -> Void) {
        let SQLQuery = """
        SELECT date_watering
        FROM watering
        WHERE plot_id=\(plotsID);
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }
                if let newInfo = try? JSONDecoder().decode(WateringPlots.self, from: data) {
                    completion(newInfo, nil)

                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getTypesTrees(completion: @escaping (TypeTreesParse?, String?) -> Void) {
        let SQLQuery = """
        SELECT t.name_type, t.notes, t.type_id, f.name as fertilizer_name, p.name_plot as plot_name, t.photo, COUNT(*) as count_trees
        FROM tree
        FULL JOIN type_tree t ON tree.type_tree_id = t.type_id
        LEFT JOIN fertilizer f ON t.type_id = f.type_tree_id
        LEFT JOIN plot p on t.type_id = p.type_tree_id
        GROUP BY t.name_type, t.notes, t.type_id, f.name, p.name_plot;
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data else {
                        completion(nil, "Data is nil")
                        return
                    }
                    if let newInfo = try? JSONDecoder().decode(TypeTreesParse.self, from: data) {
                        completion(newInfo, nil)
                        
                    } else {
                        completion(nil, "Parse error")
                        return
                    }
                }
            }.resume()
        }
    }
    
    func getAllTypeTreesWithoutConditions(completion: @escaping (AllTypeTreesParse?, String?) -> Void) {
        let SQLQuery = """
        SELECT type_id, name_type FROM type_tree;
        """
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, "Data is nil")
                    return
                }
                if let newInfo = try? JSONDecoder().decode(AllTypeTreesParse.self, from: data) {
                    completion(newInfo, nil)

                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    func getUserInfo(user userEmail: String = "dimapermyakov55@gmail.com", password userPassword: String = "boss", completion: @escaping (UsersParse?, URLResponse?, String?) -> Void) {
        let SQLQuery = """
        SELECT *
        FROM users
        WHERE password='\(userPassword)' AND login = '\(userEmail)';
        """
        let urlString = "http://\(host):\(port)/database/"
        let encodedQuery = SQLQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let correctURL = urlString + encodedQuery
        
        guard let url = URL(string: correctURL) else {
            completion(nil, nil, "Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Если сервер ответил, но ошибка.
                if let _ = response as? HTTPURLResponse {
                    completion(nil, response, error.localizedDescription)
                    return
                   
                    // Если сервер не включен. Повторный запрос к серверу.
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        self.getUserInfo(completion: completion)
                        return
                    }
                }
            }
            DispatchQueue.main.async {
                guard let data = data else {
                    completion(nil, response, "Data is nil")
                    return
                }
                
                if let newInfo = try? JSONDecoder().decode(UsersParse.self, from: data) {
                    completion(newInfo, response, nil)
                    
                } else {
                    completion(nil, response, "Parse error")
                    return
                }
            }
        }.resume()
    }
    
    
    // MARK: - Updates or Delete or Insert.
    func generalUpdate(SQLQuery: String, completion: @escaping (String?, String?) -> Void) {
        let urlString = "http://\(host):\(port)/database/"
        let encodedQuery = SQLQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let correctURL = urlString + encodedQuery
        guard let url = URL(string: correctURL) else {
            completion(nil, "Неверный url")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, "Data is empty")
                return
            }
            
            completion(String(decoding: data, as: UTF8.self), nil)
        }.resume()
        
    }
    
    func updateWithSlash(SQLQuery: String, completion: @escaping (RespondDB?, String?) -> Void) {
        let correctSQL = SQLQuery.replacingOccurrences(of: "/", with: "%2F")
        let urlString = "http://\(host):\(port)/database/update/"
        let encodedQuery = correctSQL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let correctURL = urlString + encodedQuery
        guard let url = URL(string: correctURL) else {
            completion(nil, "Неверный url")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, "Data is empty")
                return
            }
            if let info = try? JSONDecoder().decode(RespondDB.self, from: data) {
                completion(info, nil)

            } else {
                completion(nil, "Parse error")
                return
            }

        }.resume()
    }
    
}

// MARK: - Распрарс.
struct Employers: Decodable {
    let rows: [Rows]
}

struct Rows: Decodable {
    let employer_id  : String
    let full_name    : String
    let post         : String
    let phone_number : String
    let photo        : URL?
    let name_plot    : String?
    let name_type    : String?
}

struct AllEmployeesAndTypes: Decodable {
    let rows: [AllEmployeesAndTypesRows]
}

struct AllEmployeesAndTypesRows: Decodable {
    let employer_id  : String?
    let full_name    : String?
    let type_id      : String?
    let name_type    : String?
}

struct TreesParse: Decodable {
    let rows: [RowsTrees]
}

struct RowsTrees: Decodable {
    let tree_id           : String
    let name_tree         : String
    let volume            : Int
    let date_measurements : String
    let notes             : String?
    let name_type         : String
    let name_plot         : String?
    let x_begin           : Int
    let x_end             : Int
    let y_begin           : Int
    let y_end             : Int
    let photo             : URL
}

struct WateringEmployee: Decodable {
    let rows: [RowsWateringEmployee]
}

struct RowsWateringEmployee: Decodable {
    let date_: String
}

struct PlotsParse: Decodable {
    let rows: [RowsPlots]
}

struct RowsPlots: Decodable {
    let plot_id       : String
    let name_plot     : String
    let date_planting : String
    let address       : String
    let name_type     : String
    let full_name     : String
    let photo         : URL?
    let name          : String?
    let counttrees    : String
    let employer_id   : String
    let type_tree_id  : Int
    let typephoto     : URL
}

struct FeritilizerParse: Decodable {
    let rows: [RowsFeritilizer]
}

struct RowsFeritilizer: Decodable {
    let fertilizer_id : String
    let name          : String
    let price         : Int
    let mass          : Int
    let name_type     : String?
    let name_supplier : String
    let photo         : URL?
}

struct SupplierParse: Decodable {
    let rows: [RowsSupplier]
}

struct RowsSupplier: Decodable {
    let supplier_id   : String
    let name_supplier : String
    let telephone     : String?
    let www           : URL?
    let photo         : URL?
}

struct DeliveriesParse: Decodable {
    let rows: [RowsDelivery]
}

struct RowsDelivery: Decodable {
    let delivery_id     : String
    let date_delivery   : String
    let numbers_packets : Int
    let price_order     : Int
    let name_supplier   : String
    let name            : String
}
 
struct WateringPlots: Decodable {
    let rows: [RowsWateringPlots]
}

struct RowsWateringPlots: Decodable {
    let date_watering: String
}

struct TypeTreesParse: Decodable {
    let rows: [RowsTypeTrees]
}

struct RowsTypeTrees: Decodable {
    let type_id         : String
    let name_type       : String
    let notes           : String?
    let fertilizer_name : String?
    let plot_name       : String?
    let count_trees     : String
    let photo           : URL
}

struct AllTypeTreesParse: Decodable {
    let rows: [RowsAllTypeTrees]
}

struct RowsAllTypeTrees: Decodable {
    let type_id         : String
    let name_type       : String
}

struct UsersParse: Decodable {
    let rows: [RowsUser]
}

struct RowsUser: Decodable {
    let userid    : Int
    let login     : String
    let password  : String
    let photo     : URL?
    let firstname : String
    let lastname  : String
    let post      : String
}

struct RespondDB: Decodable {
    let name: String
}
// MARK: - Итоговые структуры.
struct EmpoyeeResult: Codable, Identifiable {
    let id       : String
    let fullName : String
    let phone    : String
    let post     : String
    let ava      : URL?
    let namePlot : String
    let nameType : String
}

struct AllEmpoyeesResult: Codable, Identifiable {
    let id       : String?
    let fullName : String?
    let typeID   : String?
    let typeName : String?
}

struct TreeResult: Codable, Identifiable {
    let id                : String
    let name_tree         : String
    let volume            : Int
    let date_measurements : String
    let notes             : String?
    let name_type         : String
    let name_plot         : String?
    let x_begin           : Int
    let x_end             : Int
    let y_begin           : Int
    let y_end             : Int
    let photo             : URL
}

struct PlotResult: Codable, Identifiable {
    let id             : String
    let name           : String
    let date           : String
    let address        : String
    let employee       : String
    let emp_photo      : URL?
    let type_tree      : String
    let fertilizerName : String?
    let countTrees     : String
    let employerID     : String
    let typeTreeID     : Int
    let typephoto      : URL
}

struct FertilizerResult: Codable, Identifiable {
    let id              : String
    let nameFertilizer  : String
    let priceFertilizer : Int
    let massFertilizer  : Int
    let typeTree        : String?
    let nameSupplier    : String
    let photo           : URL?
}

struct SupplierResult: Codable, Identifiable {
    let id            : String
    let name_supplier : String
    let telephone     : String?
    let www           : URL?
    let photo         : URL?
}

struct DeliveryResult: Codable, Identifiable {
    let id             : String
    let dateDelivery   : String
    let numbersPackets : Int
    let priceOrder     : Int
    let supplierName   : String
    let fertilizerName : String
}

struct TypeTreesResult: Codable, Identifiable {
    let id             : String
    let nameType       : String
    let notes          : String?
    let firtilizerName : String?
    let plotName       : String?
    let countTrees     : String
    let photo          : URL
}

struct AllTypeTreesResult: Codable, Identifiable {
    let id             : String
    let nameType       : String
}

struct UserResult: Codable, Identifiable {
    let id        : Int
    let login     : String
    let password  : String
    let photo     : URL?
    let firstname : String
    let lastname  : String
    let post      : String
}
