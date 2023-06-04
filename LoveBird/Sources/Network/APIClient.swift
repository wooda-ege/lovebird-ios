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
    var signUp:  @Sendable () async throws -> ResponseExample
    struct Failure: Error, Equatable {}
}

extension APIClient {
    static let live = Self(
        signUp: {
//            let (data, _) = try await URLSession.shared
//                .data(from: URL(string: "https://fakestoreapi.com/products")!)
//            let response = try JSONDecoder().decode(ResponseExample.self, from: data)
//            return response
            return ResponseExample(a: 1, b: 2)
        }
    )
}

struct ResponseExample: Equatable, Decodable {
    let a: Int
    let b: Int
}

extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}

extension APIClient: TestDependencyKey {
    static let testValue = Self(
        signUp: unimplemented("\(Self.self).signUp")
    )
}
