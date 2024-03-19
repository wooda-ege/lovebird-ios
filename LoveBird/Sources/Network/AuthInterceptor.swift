////
////  AuthInterceptor.swift
////  LoveBird
////
////  Created by 이예은 on 3/17/24.
////
//
//import Foundation
//import ComposableArchitecture
//import Moya
//import MapKit
//
//class AuthInterceptor: RequestInterceptor {
//
//  @Dependency(\.userData) var userData
//
//  static let shared = AuthInterceptor()
//
//  private init() {}
//
//  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//    guard urlRequest.url?.absoluteString.hasPrefix(Config.baseURL) == true else {
//      completion(.success(urlRequest))
//      return
//    }
//
//    let accessToken = userData.accessToken.value
//    let refreshToken = userData.accessToken.value
//
//    var urlRequest = urlRequest
//    urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
//    urlRequest.setValue(refreshToken, forHTTPHeaderField: "Refresh")
//
//    completion(.success(urlRequest))
//  }
//
//  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//    print("retry 진입")
//    guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
//    else {
//      completion(.doNotRetryWithError(error))
//      return
//    }
//
//
//    // 토큰 갱신 API 호출
////        UserManager.shared.getNewToken { result in
////            switch result {
////            case .success:
////                print("Retry-토큰 재발급 성공")
////                completion(.retry)
////            case .failure(let error):
////                // 갱신 실패 -> 로그인 화면으로 전환 (토큰 관련 클래스를 만들어서, 전역으로 사용할 수 있게, 그 값을 루트에서 바라보고, 그 값의 변화가 생겼을때 루트에게 보여주기)/ 퍼블리셔(컴바인인데 tca에서 쓸수있게 래핑해놈)가 토큰 매니저의 어떤 값이 왔을경우 액션을 취하도록. 
////                completion(.doNotRetryWithError(error))
////            }
////        }
//    }
//}
//
//extension APIClient: TargetType {
//    var validationType: ValidationType {
//        return .successCodes
//    }
//}
