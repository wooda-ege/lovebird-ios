//
//  OnboardingProfileView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/30.
//

import SwiftUI
import ComposableArchitecture
import UIKit

struct OnboardingProfileView: View {
  let store: StoreOf<OnboardingCore>
  @State var image: UIImage?
  @StateObject private var keyboard = KeyboardResponder()
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .center) {
        ImagePickerView(use: "profile", selectedUIImage: self.$image, representImage: Image(R.image.ic_profile))
          .frame(width: 124, height: 124, alignment: .center)
        
        Spacer()

        CommonHorizontalButton(
          title: "확인",
          backgroundColor: self.image != nil ? .black : Color(R.color.gray05)
        ) {
          viewStore.send(.imageSelected(self.image))
          viewStore.send(.nextTapped)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, UIApplication.edgeInsets.bottom + 20)
      }
    }
  }
}

//struct OnboardingProfileView_Previews: PreviewProvider {
//  static var previews: some View {
//    OnboardingProfileView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
//  }
//}


