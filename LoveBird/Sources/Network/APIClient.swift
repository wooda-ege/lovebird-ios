//
//  APIClient.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/30.
//

import Foundation
import ComposableArchitecture
import Dependencies
import Alamofire
import UIKit

struct APIClient {
  
  func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
    do {
      let (data, httpResponse) = try await self.performRequest(endpoint)
      print("⭐️\(httpResponse.statusCode)")
      let result = try self.processResponse(data, httpResponse) as NetworkResponse<T>
      return result.data
    } catch {
      throw ResponseError.unknown
    }
  }
  
  func requestMultipartform(accessToken: String, refreshToken: String, image: UIImage?, signUpRequest: SignUpRequest) async throws -> SignUpResponse {
    let url = URL(string: "https://lovebird-api.com/api/v1/profile")
    
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    let boundary = UUID().uuidString
    let contentType = "multipart/form-data; boundary=\(boundary)"
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    request.setValue("eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE3MjE4ODI0ODd9.SkY9QmDQZ9ICU7LCeAKOQ4TGuDQOEmmwjplFpgxPVubLvJsng_heZ38LCXpDdjQ6mqGhtje8E9_XtKNmtjn9gA", forHTTPHeaderField: "Authorization")
    request.setValue("eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjIxNDc0ODM2NDciLCJleHAiOjE2OTE1NTYwODd9.k-eP6sIX0VFGWY_Lqt5iAl5ox-h54knkDhpfA8Mk75D22LYWNGQcjE-lRIU4v_RckRWtPi1ST-TP9__IH-nJ7Q", forHTTPHeaderField: "Refresh")
    var body = Data()
    body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    if let image {
      body.append(image.pngData()!)      
    }
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"profileCreateRequest\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
    let jsonEncoder = JSONEncoder()
    let jsonData = try jsonEncoder.encode(signUpRequest)
    body.append(jsonData)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)--".data(using: .utf8)!)
    
    request.httpBody = body
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse else {
      throw ResponseError.noResponse
    }
    print("⭐️\(httpResponse.statusCode)")
    
    guard let result = try? JSONDecoder().decode(SignUpResponse.self, from: data) else {
      throw ResponseError.decode
    }
    
    return result
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
    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
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
    case 300...399:
      throw ResponseError.unexpectedStatusCode
    case 400...499:
      // TODO: 예시. 차후에 논의해야 됨.
      throw ResponseError.unauthorized
    case 500...599:
      throw ResponseError.invalidURL
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
