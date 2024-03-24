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
    var failReissue: Bool = false {
        didSet {
            failReissueSubject.send(failReissue)
        }
    }

    private let failReissueSubject = PassthroughSubject<Bool, Never>()

    var failReissuePublisher: AnyPublisher<Bool, Never> {
        return failReissueSubject.eraseToAnyPublisher()
    }
}
