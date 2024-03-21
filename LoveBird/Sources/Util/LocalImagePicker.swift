//
//  LocalImagePicker.swift
//  LoveBird
//
//  Created by 황득연 on 12/26/23.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct LocalImagePicker: UIViewControllerRepresentable {
  @Binding var selectedImage: Data?
  @Environment(\.presentationMode) var presentationMode

  func makeUIViewController(context: Context) -> UIImagePickerController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var parent: LocalImagePicker

    init(_ parent: LocalImagePicker) {
      self.parent = parent
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      if let image = info[.originalImage] as? UIImage {
        parent.selectedImage = image.jpegData(compressionQuality: 0.5)
      }
      parent.presentationMode.wrappedValue.dismiss()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
