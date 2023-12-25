//
//  LoadingController.swift
//  LoveBird
//
//  Created by 황득연 on 12/13/23.
//

import Combine
import SwiftUI

final class LoadingController: ObservableObject {
  @Published var isLoading: Bool = false
}
