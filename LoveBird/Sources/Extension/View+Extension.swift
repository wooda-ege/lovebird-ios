//
//  View+Extension.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import UIKit

extension View {
  func frame(size: CGFloat? = nil, alignment: Alignment = .center) -> some View {
    self.frame(width: size, height: size, alignment: alignment)
  }

  func ifTapped(completion: @escaping () -> Void) -> some View {
    return self.background(Color.white.onTapGesture {
      completion()
    })
  }

  func onTouch(_ action: @escaping () -> Void) -> some View {
    return gesture(TapGesture()
      .onEnded {
        action()
      }
    )
    .gesture(DragGesture(minimumDistance: 0)
      .onEnded { _ in
        action()
      }
    )
  }

  func onFirstAppear(_ action: @escaping () -> Void) -> some View {
      modifier(OnFirstAppearModifier(action: action))
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

  func bottomBorder(color: Color = Color(asset: LoveBirdAsset.gray04)) -> some View {
    return self.overlay(
      Rectangle()
        .fill(color)
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

  func scrollViewOrigin(callback: @escaping (CGFloat) -> Void) -> some View {
    return background(
      GeometryReader { proxy in
        let origin = proxy.frame(in: .global).origin.y
        DispatchQueue.main.async {
          callback(origin)
        }
        return Color.clear
      }
    )
  }
}
