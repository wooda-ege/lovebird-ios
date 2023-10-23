//
//  View+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import UIKit

extension View {
  func ifTapped(completion: @escaping () -> Void) -> some View {
    return self.background(Color.white.onTapGesture {
      completion()
    })
  }

  func showClearButton(
    _ text: Binding<String>,
    isFocused: Bool = true,
    trailingPadding: CGFloat = 18
  ) -> some View {
    return self.modifier(TextFieldClearButton(
      fieldText: text,
      isFocused: isFocused,
      trailingPadding: trailingPadding
    ))
  }
  
  func roundedBackground(cornerRadius: Int, color: Color) -> some View {
    return self.background(
      RoundedRectangle(cornerRadius: 12)
        .strokeBorder(color, lineWidth: 1)
    )
  }

  func bottomBorder() -> some View {
    return self.overlay(
      Rectangle()
        .fill(Color(asset: LoveBirdAsset.gray04))
        .frame(height: 1),
      alignment: .bottom
    )
  }
  
  func bottomSheet<Content: View>(isShown: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
    return self.overlay(
        HalfSheetHelper(content: content(), isShown: isShown)
      )
  }
  
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }

  func sizeChanges(onChange: @escaping (CGSize) -> Void) -> some View {
    return background(
      GeometryReader { proxy in
        Color.clear
          .preference(key: SizeChangesPreferenceKey.self, value: proxy.size)
      }
    )
    .onPreferenceChange(SizeChangesPreferenceKey.self, perform: onChange)
  }

  func scrollViewOrigin(callback: @escaping (CGPoint) -> Void) -> some View {
    return background(
      GeometryReader { proxy in
        let origin = proxy.frame(in: .global).origin
        DispatchQueue.main.async {
          callback(origin)
        }
        return Color.clear
      }
    )
  }
}

private struct SizeChangesPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}


private struct OffsetPreferenceKey: PreferenceKey {

  static var defaultValue: CGPoint = .zero

  static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}

