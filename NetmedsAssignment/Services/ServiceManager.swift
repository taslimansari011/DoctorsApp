//
//  ServiceHandler.swift
//  NetmedsAssignment
//
//  Created by macadmin on 15/06/21.
//

import Foundation

final class ServiceManager {
    
    static func getRequest<T: Decodable>(url: URL, resultType: T.Type, completionHandler: @escaping (_ result: Result<T, HTTPError>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                do {
                    if let data = data {
                        let result = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(.success(result))
                    } else {
                        completionHandler(.failure(.error(nil, ErrorMessage.default)))
                    }
                } catch (let error) {
                    completionHandler(.failure(.error(nil, error.localizedDescription)))
                }
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    completionHandler(.failure(.error(httpResponse.statusCode, error?.localizedDescription ?? ErrorMessage.default)))
                }
            }
        }.resume()
    }
}
