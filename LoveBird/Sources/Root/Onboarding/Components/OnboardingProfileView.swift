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

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .center) {
        Button { viewStore.send(.imagePickerVisible(true)) } label: {
          if let image = Image(data: viewStore.profileImage) {
            image
              .resizable()
              .scaledToFill()
              .frame(width: 124, height: 124)
              .cornerRadius(10)
              .clipped()
          } else {
            Image(asset: LoveBirdAsset.icProfile)
              .frame(width: 124, height: 124)
          }
        }
        .padding(.top, 16)

        Spacer()

        CommonHorizontalButton(
          title: "다음",
          backgroundColor: viewStore.profileImage != nil ? .black : Color(asset: LoveBirdAsset.gray05)
        ) {
          viewStore.send(.nextTapped)
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 16)
      }
      .sheet(isPresented: viewStore.binding(
        get: { $0.isImagePickerVisible },
        send: OnboardingAction.imagePickerVisible
      )) {
        LocalImagePicker(selectedImage: viewStore.binding(
          get: { $0.profileImage },
          send: OnboardingAction.profileSelected
        ))
      }
    }
  }
}

#Preview {
  OnboardingProfileView(
    store: Store(
      initialState: OnboardingState(
        auth: .init(
          provider: .kakao,
          idToken: ""
        )
      ),
      reducer: {
        OnboardingCore()
      }
    )
  )
}
