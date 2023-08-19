//
//  HalfSheetHelper.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/19.
//

import SwiftUI

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
