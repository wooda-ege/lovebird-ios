//
//  NetworkResponse.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/06.
//

import Foundation

struct NetworkResponse<T> {
    let status: Int
    let message: String
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
}

extension NetworkResponse: Decodable where T: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try! container.decode(Int.self, forKey: .status)
        self.message = try! container.decode(String.self, forKey: .message)
        self.data = try! container.decode(T.self, forKey: .data)
    }
}

struct NetworkStatusResponse {
    let status: Int
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
    }
}

extension NetworkStatusResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try! container.decode(Int.self, forKey: .status)
        self.message = try! container.decode(String.self, forKey: .message)
    }
}
