//
//  ImagePicker.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/31.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
  
  @Binding var image: UIImage?
  @Environment(\.presentationMode) var mode
  
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
    let picker = UIImagePickerController()
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}

extension ImagePicker {
  class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    
    init(_ parent: ImagePicker) {
      self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let image = info[.originalImage] as? UIImage else { return }
      parent.image = image
      parent.mode.wrappedValue.dismiss()
    }
  }
}

struct ImagePickerView: View {
  
  @State var showImagePicker = false
  @Binding var selectedUIImage: UIImage?
  @State var image: Image?
  
  func loadImage() {
    guard let selectedImage = selectedUIImage else { return }
    image = Image(uiImage: selectedImage)
  }
  
  var body: some View {
    HStack(spacing: 10) {
      if let image = image {
        image
          .resizable()
          .cornerRadius(32)
          .frame(width: 124, height: 124)
      } else {
        Button {
          showImagePicker.toggle()
        } label: {
          Image(R.image.ic_profile)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 124, height: 124)
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
          loadImage()
        }) {
          ImagePicker(image: $selectedUIImage)
        }
      }
      
      Spacer()
    }
    .padding(.leading, 5)
  }
}

//struct ImageViewTester_Previews: PreviewProvider {
//  static var previews: some View {
//    ImagePickerView(, selectedUIImage: <#Binding<UIImage?>#>)
//  }
//}

