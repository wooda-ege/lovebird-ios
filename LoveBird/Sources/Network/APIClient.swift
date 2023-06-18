//
//  APIClient.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/30.
//

import Foundation
import ComposableArchitecture
import Dependencies

struct APIClient {
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        do {
            let (data, httpResponse) = try await self.performRequest(endpoint)
            let result = try self.processResponse(data, httpResponse) as NetworkResponse<T>
            return result.data
        } catch {
            throw ResponseError.unknown
        }
    }

    func requestRaw<T: Decodable>(_ endpoint: APIEndpoint) async throws -> NetworkResponse<T> {
        do {
            let (data, httpResponse) = try await self.performRequest(endpoint)
            let result = try self.processResponse(data, httpResponse) as NetworkResponse<T>
            return result
        } catch {
            throw ResponseError.unknown
        }
    }
    
    private func performRequest(_ endpoint: APIEndpoint) async throws -> (Data, HTTPURLResponse) {
        let url = URL(string: Config.baseURL + endpoint.path)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        // TODO: 득연 - 차후에 토큰 등이 들어갈 예정
//        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.requestBody {
            urlRequest.httpBody = try JSONEncoder().encode(body)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ResponseError.noResponse
        }

        return (data, httpResponse)
    }
    
    private func processResponse<T: Decodable>(_ data: Data, _ httpResponse: HTTPURLResponse) throws -> NetworkResponse<T> {
        switch httpResponse.statusCode {
        case 200...299:
            guard let result = try? JSONDecoder().decode(NetworkResponse<T>.self, from: data) else {
                throw ResponseError.decode
            }
            return result
        case 401:
            // TODO: 예시. 차후에 논의해야 됨.
            throw ResponseError.unauthorized
        default:
            throw ResponseError.unexpectedStatusCode
        }
    }
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

extension APIClient: DependencyKey {
    static let liveValue = Self()
}
