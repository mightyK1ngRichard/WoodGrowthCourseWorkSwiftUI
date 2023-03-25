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
    
    func getDataUsingCommand(SQLQuery: String, completion: @escaping (String?, String?) -> Void) {
        let SQLQueryInCorrectForm = SQLQuery.replacingOccurrences(of: " ", with: "%20").replacingOccurrences(of: "\n", with: "%20")
        let urlString = "http://\(host):\(port)/database/\(SQLQueryInCorrectForm)"
        guard let url = URL(string: urlString) else {
            completion(nil, "== Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, "Data is empty")
                return
            }
            
            // ... Сделать механизм распарсинга.
            completion(String(decoding: data, as: UTF8.self), nil)
        }.resume()
    }
    
    func getEmployers(completion: @escaping (Employers?, String?) -> Void) {
        let SQLQuery = """
        SELECT * FROM employer;
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
    
    func getTrees(completion: @escaping (TreesParse?, String?) -> Void) {
        let SQLQuery = """
        select tree.tree_id, tree.name_tree, tree.volume, tree.date_measurements, tree.notes, type_tree.name_type, plot.name_plot, coordinates.x_begin, coordinates.x_end, coordinates.y_begin, coordinates.y_end
        from tree
        join plot ON tree.plot_id=plot.plot_id
        join coordinates ON coordinates.tree_id=tree.tree_id
        join type_tree ON type_tree.type_id=tree.type_tree_id
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
        SELECT plot.plot_id, plot.name_plot, plot.date_planting, plot.address, type_tree.name_type,
        employer.full_name, employer.photo
        FROM plot
        JOIN employer ON plot.employer_id=employer.employer_id
        JOIN type_tree ON plot.plot_id=type_tree.type_id

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
        select fertilizer.fertilizer_id, fertilizer.name, fertilizer.price, fertilizer.mass,
        type_tree.name_type
        from fertilizer
        join type_tree on fertilizer.type_tree_id=type_tree.type_id
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
}

// MARK: - Распрарсинг.
struct Employers: Decodable {
    let rows: [Rows]
}

struct Rows: Decodable {
    let employer_id: String
    let full_name: String
    let post: String
    let phone_number: String
    let photo: URL?
    
}

struct TreesParse: Decodable {
    let rows: [RowsTrees]
}

struct RowsTrees: Decodable {
    let tree_id: String
    let name_tree: String
    let volume: Int
    let date_measurements: String
    let notes: String?
    let name_type: String
    let name_plot: String
    let x_begin: Int
    let x_end: Int
    let y_begin: Int
    let y_end: Int
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
    let plot_id: String
    let name_plot: String
    let date_planting: String
    let address: String
    let name_type: String
    let full_name: String
    let photo: URL?
}

struct FeritilizerParse: Decodable {
    let rows: [RowsFeritilizer]
}

struct RowsFeritilizer: Decodable {
    let fertilizer_id: String
    let name: String
    let price: Int
    let mass: Int
    let name_type: String
}
// MARK: - Итоговые структуры.
struct EmpoyeeResult: Codable, Identifiable {
    let id: String
    let fullName: String
    let phone: String
    let post: String
    let ava: URL?
}

struct TreeResult: Codable, Identifiable {
    let id: String
    let name_tree: String
    let volume: Int
    let date_measurements: String
    let notes: String?
    let name_type: String
    let name_plot: String
    let x_begin: Int
    let x_end: Int
    let y_begin: Int
    let y_end: Int
}

struct PlotResult: Codable, Identifiable {
    let id: String
    let name: String
    let date: String
    let address: String
    let employee: String
    let emp_photo: URL?
    let type_tree: String
}

struct FertilizerResult: Codable, Identifiable {
    let id: String
    let nameFertilizer: String
    let priceFertilizer: Int
    let massFertilizer: Int
    let typeTree: String
}
