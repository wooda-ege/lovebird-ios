//
//  ImagePicker.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/06.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var isImagePickerDisplayed: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image, isImagePickerDisplayed: $isImagePickerDisplayed)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?
        @Binding var isImagePickerDisplayed: Bool

        init(image: Binding<UIImage?>, isImagePickerDisplayed: Binding<Bool>) {
            _image = image
            _isImagePickerDisplayed = isImagePickerDisplayed
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                image = uiImage
            }
            isImagePickerDisplayed = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isImagePickerDisplayed = false
        }
    }
}

struct ImagePickerView: View {
  @State var showImagePicker = false
  @State var selectedUIImage: UIImage?
  @Binding var image: Image?
  
  func loadImage() {
    guard let selectedImage = selectedUIImage else { return }
    image = Image(uiImage: selectedImage)
  }
  
  var body: some View {
    HStack(spacing: 10) {
      if let image = image {
        image
          .resizable()
          .cornerRadius(10)
          .frame(width: 80, height: 80)
      } else {
        Button {
          showImagePicker.toggle()
        } label: {
          Image(systemName: "plus.viewfinder")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color(uiColor: .secondarySystemBackground))
            .frame(width: 80, height: 80)
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
          loadImage()
        }) {
          ImagePicker(image: $selectedUIImage, isImagePickerDisplayed: $showImagePicker)
        }
      }
      
      Spacer()
    }
    .padding(.leading, 5)
  }
}
//
//struct ImageViewTester_Previews: PreviewProvider {
//  static var previews: some View {
//    ImagePickerView()
//  }
//}
