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
        .fill(Color(R.color.gray04))
        .frame(height: 1),
      alignment: .bottom
    )
  }
  
  func bottomSheet<Content: View>(isShown: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
    return self
      .overlay(
        HalfSheetHelper(content: content(), isShown: isShown)
      )
  }
  
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

struct HalfSheetHelper<Content: View>: UIViewControllerRepresentable {
  
  var content: Content
  @Binding var isShown: Bool
  
  let controller = UIViewController()
  
  func makeUIViewController(context: Context) -> UIViewController {
    controller.view.backgroundColor = .white
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    if self.isShown {
      let sheetController = UIHostingController(rootView: content)
      uiViewController.present(sheetController, animated: true) {
        
        DispatchQueue.main.async {
          self.isShown.toggle()
        }
      }
    }
  }
}
