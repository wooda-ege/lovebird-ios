//
//  ImagePicker.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/06.
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
          ImagePicker(image: $selectedUIImage)
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
