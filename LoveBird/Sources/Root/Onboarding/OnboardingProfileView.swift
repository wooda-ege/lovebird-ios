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
    WithViewStore(self.store) { viewStore in
      VStack(alignment: .center) {
        ImagePickerView(use: "profile", selectedUIImage: $image, representImage: Image(R.image.ic_profile))
          .frame(width: 124, height: 124, alignment: .center)
        
        Spacer()
        
        Button {
          viewStore.send(.imageSelected(image))
          viewStore.send(.nextTapped)
        } label: {
          TouchableStack {
            Text(R.string.localizable.common_next)
              .font(.pretendard(size: 16, weight: .semiBold))
              .foregroundColor(.white)
          }
        }
        .frame(height: 56)
        .background(.black)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.bottom, 54)
        .background(.white)
      }
    }
  }
}

//struct OnboardingProfileView_Previews: PreviewProvider {
//  static var previews: some View {
//    OnboardingProfileView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
//  }
//}


