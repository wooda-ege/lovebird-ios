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
  
  func requestRaw(_ endpoint: APIEndpoint) async throws -> NetworkStatusResponse {
    do {
      let (data, httpResponse) = try await self.performRequest(endpoint)
      let result = try self.networkResponse(data, httpResponse)
      return result
    } catch {
      throw ResponseError.unknown
    }
  }
  
  private func performRequest(_ endpoint: APIEndpoint) async throws -> (Data, HTTPURLResponse) {
    let url = URL(string: Config.baseURL + endpoint.path)!
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = endpoint.method.rawValue
    urlRequest.setValue("eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE3MjE4ODI0ODd9.SkY9QmDQZ9ICU7LCeAKOQ4TGuDQOEmmwjplFpgxPVubLvJsng_heZ38LCXpDdjQ6mqGhtje8E9_XtKNmtjn9gA", forHTTPHeaderField: "Authorization")

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

  private func networkResponse(_ data: Data, _ httpResponse: HTTPURLResponse) throws -> NetworkStatusResponse {
    switch httpResponse.statusCode {
    case 200...299:
      guard let result = try? JSONDecoder().decode(NetworkStatusResponse.self, from: data) else {
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
