//
//  OnboardingBirthDateView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/07/03.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingBirthDateView: View {
  let store: StoreOf<OnboardingCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        OnboardingDateView(
          date: viewStore.birth,
          onTap: { viewStore.send(.birthdayPickerViewVisible(true)) })
        .padding(.top, 24)
        .padding(.horizontal, 16)

        Spacer()
        
        CommonHorizontalButton(title: "다음") {
          viewStore.send(.nextButtonTapped)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
      }
      .background(.white)
    }
  }
}

#Preview {
  OnboardingBirthDateView(
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

