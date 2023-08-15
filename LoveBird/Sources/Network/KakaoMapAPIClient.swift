////
////  KakaoMapAPIClient.swift
////  LoveBird
////
////  Created by 이예은 on 2023/08/14.
////
//
//import Moya
//import Alamofire
//import ComposableArchitecture
//import Dependencies
//import Alamofire
//import UIKit
//import SwiftUI
//
//// Public인 DependencyKey 때문에 불가피하게 public으로 선언한다.
//public enum KakaoMapAPIClient {
//  case searchKakaoMap(searchTerm: String)
//}
//
//extension KakaoMapAPIClient: TargetType {
//  
//  public var baseURL: URL {
//    URL(string: Config.kakaoMapURL)!
//  }
//  
//  public var path: String {
//    switch self {
//    case .searchKakaoMap:
//      return "/v2/local/search/keyword.json"
//    }
//  }
//  
//  public var method: Moya.Method {
//    switch self {
//    case .searchKakaoMap:
//      return .get
//    }
//  }
//  
//  public var task: Moya.Task {
//    switch self {
//    case .searchKakaoMap:
//      return .requestParameters(parameters: self.bodyParameters ?? [:], encoding: JSONEncoding.default)
//    default:
//      return .requestPlain
//    }
//  }
//  
//  // TODO: 토큰관련 수정할 것
//  public var headers: [String: String]? {
//    switch self {
//    case .searchKakaoMap:
//      return ["Authorization" : "KakaoAK e2b463ff0435646fe4d1b4213c6527b1"]
//    }
//  }
//  
//  private var bodyParameters: Parameters? {
//    var params: Parameters = [:]
//    switch self {
//    case .searchKakaoMap(let searchTerm):
//      params["query"] = searchTerm
//    }
//    return params
//  }
//}
//
//
//
//
////extension DependencyValues {
////  var kakaoMapApiClient: MoyaProvider<KakaoMapAPIClient> {
////    get { self[MoyaProvider.self] }
////    set { self[MoyaProvider.self] = newValue }
////  }
////}
////
////extension MoyaProvider<KakaoMapAPIClient>: DependencyKey, TestDependencyKey {
////  public static var liveValue = MoyaProvider<KakaoMapAPIClient>()
////}
//
