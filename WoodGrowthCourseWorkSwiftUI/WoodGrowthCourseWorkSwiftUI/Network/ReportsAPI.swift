//
//  ReportsAPI.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 21.04.2023.
//

import Foundation

class ReportsAPI {
    static var shared = ReportsAPI()
    private let host  = "localhost"
    private let port  = 8010
    
    func countOfTreeInPlot(completion: @escaping (CountTreeParse?, String?) -> Void) {
        let SQLQuery = """
        SELECT p.name_plot, SUM(t.volume) as score_volum, COUNT(t.tree_id) as count_trees
        FROM tree t
        JOIN type_tree tt ON tt.type_id=t.type_tree_id
        JOIN plot p ON p.type_tree_id=t.type_tree_id
        GROUP BY p.name_plot
        ORDER BY p.name_plot;
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

                if let newInfo = try? JSONDecoder().decode(CountTreeParse.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
        
    }
    
    func avgVolumeByDays(completion: @escaping (AvgVolumeParse?, String?) -> Void) {
        let SQLQuery = "SELECT date_measurements, AVG(volume) FROM tree GROUP BY date_measurements;"
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

                if let newInfo = try? JSONDecoder().decode(AvgVolumeParse.self, from: data) {
                    completion(newInfo, nil)
                    
                } else {
                    completion(nil, "Parse error")
                    return
                }
            }
        }.resume()
        
    }
}

struct CountTreeParse: Decodable {
    let rows: [RowsCountTreeParse]
}

struct RowsCountTreeParse: Decodable {
    let name_plot   : String
    let count_trees : String
    let score_volum : String
}

struct AvgVolumeParse: Decodable {
    let rows: [RowsAvgVolume]
}

struct RowsAvgVolume: Decodable {
    let date_measurements : String
    let avg               : String
}

