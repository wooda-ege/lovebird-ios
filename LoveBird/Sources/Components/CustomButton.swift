//
//  CustomButton.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/06.
//

import SwiftUI
import ComposableArchitecture

struct CustomButton: View {
  var title: String
  
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 10)
        .foregroundColor(Color(uiColor: .secondarySystemBackground))
        .frame(width: .infinity, height: 44, alignment: .leading)
      
      HStack {
        Label {
          Text(title)
        } icon : {
          Image("map")
            .resizable()
            .scaledToFit()
            .frame(
              width: 15,
              height: 15)
        }
        
        Spacer()
      }
      .padding(.leading, 15)
    }
  }
}

struct CompleteButton: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    Button("완료") {
      print("완료 버튼 눌렀습니동")
      self.presentationMode.wrappedValue.dismiss()
    }
    .foregroundColor(.black)
  }
}

struct BackButton: View {
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
  
  var body: some View {
    Button(action: {
      print("뒤로가기 버튼 눌렸습니동")
      self.presentationMode.wrappedValue.dismiss()
    }) {
      Image("back")
        .resizable()
        .frame(width: 10, height: 15)
    }
  }
}

struct CustomButton_Previews: PreviewProvider {
  static var previews: some View {
    CustomButton(title: "jii")
  }
}


