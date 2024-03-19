//
//  TokenManager.swift
//  LoveBird
//
//  Created by 이예은 on 3/19/24.
//

import Foundation
import ComposableArchitecture
import Combine
import SwiftUI

final class TokenManager {
  @Published var failReissue: Bool = false

  @Dependency(\.userData) var userData

  func callRecreateAPI(completion: @escaping (Result<Token, Error>) -> Void) {
      guard let url = URL(string: "https://dev-app-api.lovebird-wooda.com/api/v1/auth/recreate") else {
          completion(.failure(LovebirdError.internalServerError))
          return
      }

      let refreshToken = userData.refreshToken.value

      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      request.setValue(refreshToken, forHTTPHeaderField: "Refresh")

      URLSession.shared.dataTask(with: request) { data, response, error in
          if let error = error {
              completion(.failure(error))
              return
          }

          guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
              completion(.failure(LovebirdError.unknownError))
              return
          }

          guard let responseData = data else {
              completion(.failure(LovebirdError.unknownError))
              return
          }

          do {
              let tokenResponse = try JSONDecoder().decode(Token.self, from: responseData)
              completion(.success(tokenResponse))
          } catch {
              completion(.failure(LovebirdError.decodeError))
          }
      }.resume()
  }
}
