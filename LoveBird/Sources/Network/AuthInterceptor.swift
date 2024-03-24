//
//  AuthInterceptor.swift
//  LoveBird
//
//  Created by 이예은 on 3/17/24.
//

import Foundation
import ComposableArchitecture
import Moya
import Dependencies
import Alamofire
import UIKit
import SwiftUI

class AuthInterceptor: RequestInterceptor {

  @Dependency(\.tokenManager) var tokenManager
  @Dependency(\.userData) var userData

  static let shared = AuthInterceptor()

  private init() {}

  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {

    completion(.success(urlRequest))
  }

  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

    guard let response = request.task?.response as? HTTPURLResponse, 
            response.statusCode == LovebirdStatusCode.tokenExpired.rawValue else {
      completion(.doNotRetryWithError(error))
      return
    }

    self.callRecreateAPI { result in
      switch result {
      case .success(let token):
        self.userData.accessToken.value = token.accessToken
        self.userData.refreshToken.value = token.refreshToken

        completion(.retry)
      case .failure(let error):
        self.tokenManager.failReissueSubject.send()

        completion(.doNotRetryWithError(error))
      }
    }
  }

  func callRecreateAPI(completion: @escaping (Result<Token, Error>) -> Void) {
    guard let url = URL(string: Config.recreateURL) else {
      completion(.failure(LovebirdError.unableToCreateURLError))
      return
    }

    let refreshToken = userData.refreshToken.value
    let accessToken = userData.accessToken.value

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.setValue(accessToken, forHTTPHeaderField: "Bearer Authorization")
    request.setValue(refreshToken, forHTTPHeaderField: "Bearer Refresh")

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(LovebirdError.unknownError))
        return
      }

      guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        completion(.failure(LovebirdError.invalidHTTPResponseError))
        return
      }

      guard let data else {
        completion(.failure(LovebirdError.noReceivedDataError))
        return
      }

      do {
        let tokenResponse = try JSONDecoder().decode(Token.self, from: data)
        completion(.success(tokenResponse))
      } catch {
        completion(.failure(LovebirdError.decodeError))
      }
    }.resume()
  }
}
