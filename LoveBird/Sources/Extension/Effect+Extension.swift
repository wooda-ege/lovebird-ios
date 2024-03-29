//
//  Effect+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 12/26/23.
//

import ComposableArchitecture

extension Effect {
  static var loadingController: LoadingController {
    @Dependency(\.loadingController) var loadingController
    return loadingController
  }

  static func runWithLoading(
    priority: TaskPriority? = nil,
    operation: @escaping @Sendable (_ send: Send<Action>) async throws -> Void,
    catch handler: (@Sendable (_ error: Error, _ send: Send<Action>) async -> Void)? = nil,
    fileID: StaticString = #fileID,
    line: UInt = #line
  ) -> Self {
    return .run(
      priority: priority,
      operation: {
        loadingController.isLoading = true
        try await operation($0)
        loadingController.isLoading = false
      },
      catch: {
        loadingController.isLoading = false
        await handler?($0, $1)
      }
    )
  }
}
