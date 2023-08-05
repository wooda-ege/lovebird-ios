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
        Spacer().frame(height: 24)
        
        Text(R.string.localizable.onboarding_profile_title)
          .font(.pretendard(size: 20, weight: .bold))
          .foregroundColor(.black)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 16)
        
        Text(R.string.localizable.onboarding_profile_description)
          .font(.pretendard(size: 16, weight: .regular))
          .foregroundColor(Color(R.color.gray07))
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top, 12)
          .padding(.leading, 16)
        
        Spacer().frame(height: 48)
        
        ImagePickerView(selectedUIImage: $image)
          .padding(.horizontal, 126)
        
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

struct OnboardingProfileView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingProfileView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
  }
}


