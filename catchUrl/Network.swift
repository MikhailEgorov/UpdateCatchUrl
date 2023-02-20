//
//  Network.swift
//  catchUrl
//
//  Created by Mikhail Egorov on 18.02.2023.
//

import Foundation

enum Link: String {
    case LinkURL = "https://yesno.wtf/api"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetch(from url: String, with completion: @escaping(Result<Answer, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return}
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                print(error?.localizedDescription ?? "no error description")
                return
            }
            do {
                let answer = try JSONDecoder().decode(Answer.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(answer))
                }
                 print(answer)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchImage(from url: String?, completion: @escaping(Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else {
                completion(.failure(.noData))
                return
            }
            DispatchQueue.main.async {
                completion(.success(imageData))
            }
        }
    }
        
    }
 
