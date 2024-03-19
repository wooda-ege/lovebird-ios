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

  static let shared = AuthInterceptor()

  private init() {}

  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    completion(.success(urlRequest))
  }

  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    print("retry 진입")

    guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
      completion(.doNotRetryWithError(error))
      return
    }

    tokenManager.callRecreateAPI { result in
      switch result {
      case .success:
        print("Retry-토큰 재발급 성공")
        completion(.retry)
      case .failure(let error):
        self.tokenManager.failReissue = true
        
        completion(.doNotRetryWithError(error))
      }
    }
  }
}

