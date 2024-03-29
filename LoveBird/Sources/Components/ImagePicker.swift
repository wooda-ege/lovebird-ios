//
//  ImagePicker.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/31.
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
  var use: String
  @Binding var selectedUIImage: UIImage?
  @State var showImagePicker = false
  @State var image: Image?
  @State private var showingAlert = false
  var representImage: Image

  func loadImage() {
    guard let selectedImage = selectedUIImage else { return }
    image = Image(uiImage: selectedImage)
  }

  var body: some View {
    HStack() {
      Button {
        ImageAccessAuth.checkAlbumPermission { status in
          if status == .authorized {
            showImagePicker.toggle()
          } else {
            Button("Alert") {
              self.showingAlert.toggle()
            }
            .alert(isPresented: $showingAlert) {
              Alert(title: Text("사진 접근 권한이 없습니다."), message: Text("설정으로 이동하여 권한 설정을 해주세요."),
                    dismissButton: .default(Text("확인")))
            }
          }
        }
      } label: {
        Group {
          if let image = image {
            if use == "diary" {
              image
                .changeSize(to: .init(width: 64, height: 64))
                .cornerRadius(12)
            } else {
              image
                .changeSize(to: .init(width: 124, height: 124))
                .cornerRadius(12)
            }
          } else {
            if use == "diary" {
              representImage
                .changeSize(to: .init(width: 64, height: 64))
                .aspectRatio(contentMode: .fit)
            } else {
              representImage
                .changeSize(to: .init(width: 124, height: 124))
                .aspectRatio(contentMode: .fit)
            }
          }
        }
      }

      Spacer()
    }
    .sheet(isPresented: $showImagePicker, onDismiss: {
      loadImage()
    }) {
      ImagePicker(image: $selectedUIImage, isImagePickerDisplayed: $showImagePicker)
    }
  }
}

//struct ImageViewTester_Previews: PreviewProvider {
//  static var previews: some View {
//    ImagePickerView(, selectedUIImage: <#Binding<UIImage?>#>)
//  }
//}

