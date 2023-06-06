//
//  NetworkManager.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/31.
//

import SwiftUI
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    var cancellables = Set<AnyCancellable>()
    func execute(urlRequest: URLRequest, completion: @escaping ([PlaceInfo]) -> Void) {
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: KaKaoMap.self, decoder: JSONDecoder())
            .sink { completion in
                print("Completion: \(completion)")
            } receiveValue: { data in
                completion(data.place)
            }
            .store(in: &cancellables)
    }
}
