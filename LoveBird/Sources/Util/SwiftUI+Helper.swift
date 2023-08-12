//
//  SwiftUI+Helper.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/05.
//

import SwiftUI

extension View
{
    public func toAnyView() -> AnyView
    {
        AnyView(self)
    }
}

extension Binding where Value: Equatable
{
  /// Workaround for `NavigationLink's `isActive = false` called multiple times per dismissal.
  public func removeDuplictates() -> Binding<Value>
  {
    var previous: Value? = nil

    return Binding<Value>(
      get: { self.wrappedValue },
      set: { newValue in
        guard newValue != previous else {
          return
        }
        previous = newValue
        self.wrappedValue = newValue
      }
    )
  }

  func debug(_ prefix: String) -> Binding {
      Binding(
        get: {
          print("\(prefix): getting \(self.wrappedValue)")
          return self.wrappedValue
      },
        set: {
          print("\(prefix): setting \(self.wrappedValue) to \($0)")
          self.wrappedValue = $0
      })
    }
}
