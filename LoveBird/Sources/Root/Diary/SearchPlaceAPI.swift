//
//  SearchPlaceAPI.swift
//  JsonPractice
//
//  Created by 이예은 on 2023/05/24.
//

import Foundation

struct SearchPlaceAPI {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/local/search/keyword.json"
    
    func configureComponents(query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchPlaceAPI.scheme
        components.host = SearchPlaceAPI.host
        components.path = SearchPlaceAPI.path
        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        return components
    }
    
    func configureRequest(query: String) -> URLRequest {
        var request = URLRequest(url: self.configureComponents(query: query).url!)
        request.httpMethod = "GET"
        request.setValue("KakaoAK e2b463ff0435646fe4d1b4213c6527b1", forHTTPHeaderField: "Authorization")
        
        return request
    }
}

