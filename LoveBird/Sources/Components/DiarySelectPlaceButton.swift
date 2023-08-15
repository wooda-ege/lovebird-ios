//
//  CustomButton.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/06.
//

import SwiftUI
import ComposableArchitecture

struct DiarySelectPlaceButton: View {
  var title: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color(R.color.gray231))
        .background(.white)
        .frame(
          height: 44,
          alignment: .leading
        )
      
      HStack {
        Label {
          Text(title)
        } icon : {
          Image(R.image.ic_map)
            .resizable()
            .scaledToFit()
            .frame(
              width: 15,
              height: 15
            )
        }
        
        Spacer()
      }
      .padding(.leading, 15)
    }
    .background(Color(R.color.gray231))
  }
}

struct CompleteButton: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    Button(String(resource: R.string.localizable.complete_text)) {
      self.presentationMode.wrappedValue.dismiss()
    }
    .foregroundColor(.black)
  }
}

struct BackButton: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    Button(action: {
      self.presentationMode.wrappedValue.dismiss()
    }) {
      Image(R.image.ic_back)
        .resizable()
        .frame(width: 24, height: 24)
    }
  }
}

struct CustomButton_Previews: PreviewProvider {
  static var previews: some View {
    DiarySelectPlaceButton(title: "jii")
  }
}


