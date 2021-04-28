//
//  ListEventServices.swift
//  EventosApp
//
//  Created by Lucas Santiago on 24/04/21.
//

import Foundation

enum ListEventServiceError: Error {
    case badURL
    case emptyData
    case serverError
    case parseError
    case unknow
}

protocol ListEventServiceProtocol {
    func fetchContacts(completion: @escaping (Result<[Event],ListEventServiceError>) -> Void)
    func postCheckIn(_ checkIn:CheckIn, completion: @escaping (Result<CheckIn,ListEventServiceError>) -> Void)
}

class ListEventService: NSObject, ListEventServiceProtocol {
    
    private let apiURL: String
    private var session: URLSession
    
    init(url: String = "https://5f5a8f24d44d640016169133.mockapi.io/api/events",
         session: URLSession = URLSession.shared){
        self.apiURL = url
        self.session = session
    }
    
    func fetchContacts(completion: @escaping (Result<[Event],ListEventServiceError>) -> Void) {
        guard let api = URL(string: self.apiURL) else {
            completion(.failure(.badURL))
            return
        }
        let task = self.session.dataTask(with: api) { (data, response, error) in
            if let _ = error {
                print(error?.localizedDescription ?? "")
                completion(.failure(.serverError))
                return
            }
            guard let jsonData = data else {
                completion(.failure(.emptyData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([Event].self, from: jsonData)
                
                completion(.success(decoded))
            } catch {
                completion(.failure(.parseError))
            }
        }
        task.resume()
    }
    
    func postCheckIn(_ checkIn:CheckIn, completion: @escaping (Result<CheckIn,ListEventServiceError>) -> Void) {
        guard let api = URL(string: "http://5f5a8f24d44d640016169133.mockapi.io/api/checkin") else {
            completion(.failure(.badURL))
            return
        }
        do {
            var urlRequest = URLRequest(url: api)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(checkIn)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201, let jsonData = data else {
                    completion(.failure(.badURL))
                    return
                }
                
                guard let status = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
                    completion(.failure(.serverError))
                    return
                }
                switch status {
                case .ok:
                    completion(.success(checkIn))
                default:
                    completion(.failure(.unknow))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.parseError))
        }
    }
    
    private func createBody(_ body: [String: Any]) throws -> Data? {
        return try JSONSerialization.data(withJSONObject: body)
    }
}

extension ListEventServiceError: LocalizedError {
    var errorDescription: String?{
        switch self {
        case .badURL:
            return NSLocalizedString("Não foi possivel se conectar a API", comment: "")
        case .emptyData:
            return NSLocalizedString("Não existe conteudo na API chamada", comment: "")
        case .parseError:
            return NSLocalizedString("Não foi possivel fazer o parse do objeto", comment: "")
        case .serverError:
            return NSLocalizedString("Erro no servidor", comment: "")
        case .unknow:
            return NSLocalizedString("Erro desconhecido", comment: "")
        }
    }
}

extension ListEventService: URLSessionDelegate {
    func urlSession(_ session: URLSession,
              didReceive challenge: URLAuthenticationChallenge,
              completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
          completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
      }
}
