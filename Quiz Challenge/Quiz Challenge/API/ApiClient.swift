//
//  ApiClient.swift
//  Quiz Challenge
//
//  Created by Joao Vitor P. on 2/15/20.
//  Copyright © 2020 ArcTouch. All rights reserved.
//

import Foundation

protocol APIRequest: Encodable {
    associatedtype Response: Decodable
    var resource: String { get }
}

class ApiClient {
    var urlSession = URLSession.shared

    public static let shared = ApiClient()

    private let baseEndpointUrl = URL(string: "https://codechallenge.arctouch.com/")!

    public func send<T>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) where T : APIRequest {
        let endpoint = self.endpoint(for: request, method: "GET")
        var urlRequest = URLRequest(url: endpoint)

        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(T.Response.self, from: data)

                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    print ("Error - \(error)")
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                print ("Request error")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }

    private func endpoint<T: APIRequest>(for request: T, method: String) -> URL {
        guard let endpointUrl = URL(string: request.resource, relativeTo: baseEndpointUrl) else {
            fatalError("Bad resourceName: \(request.resource)")
        }

        return endpointUrl
    }
}
