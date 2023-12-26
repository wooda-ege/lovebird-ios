//
//  _ReducerPrinter+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 12/26/23.
//

import ComposableArchitecture

extension _ReducerPrinter {
  public static var lovebirdDump: Self {
    Self { receivedAction, oldState, newState in
      guard filterActionIfNeeded(receivedAction).not else { return }

      var target = ""
      target.write("received action:\n")
      CustomDump.customDump(receivedAction, to: &target, indent: 2)
      target.write("\n")
      target.write(diff(oldState, newState).map { "\($0)\n" } ?? "  (No state changes)\n")
      print(target)
    }
  }

  static func filterActionIfNeeded(_ receivedAction: Action) -> Bool {
    if case let .path(mainAction)  = receivedAction as? RootAction,
       case let .mainTab(mainTabAction) = mainAction,
       case let .home(homeAction) = mainTabAction,
       case .offsetYChanged = homeAction { return true }
    return false
  }
}
