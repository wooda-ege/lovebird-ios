//
//  DependencyValues+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 12/8/23.
//

import ComposableArchitecture
import Moya

extension DependencyValues {
  var lovebirdApi: LovebirdAPI {
    get { self[LovebirdAPI.self] }
    set { self[LovebirdAPI.self] = newValue }
  }
}

extension LovebirdAPI: DependencyKey {
  public static var liveValue = LovebirdAPI(apiClient: MoyaProvider<APIClient>())
}
