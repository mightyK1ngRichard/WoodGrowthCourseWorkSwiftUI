//
//  APIManager.swift
//  WoodGrowthCourseWorkSwiftUI
//
//  Created by Дмитрий Пермяков on 20.03.2023.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    let host = "localhost"
    let port = 8010

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
            completion(nil, "== Uncorrected url")
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data else { return }
                if let newInfo = try? JSONDecoder().decode(Employers.self, from: data) {
                   completion(newInfo, nil)
                } else {
                    completion(nil, "== Parse error")
                    return
                }
            }
        }.resume()
    }
}
    
// MARK: - Распрарсинг.
struct Employers: Decodable{
    let rows: [Rows]
}

struct Rows: Decodable {
    let employer_id: String
    let full_name: String
    let post: String
    let phone_number: String
    let photo: URL?

}

// MARK: - Итоговая структура работника.
struct EmpoyeeResult: Codable, Identifiable {
    let id: String
    let fullName: String
    let phone: String
    let post: String
    let ava: URL?
}
