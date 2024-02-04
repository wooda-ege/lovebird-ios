//
//  OnboardingAnniversaryView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingFirstDateView: View {

  let store: StoreOf<OnboardingCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        OnboardingDateView(
          date: viewStore.firstDate,
          onTap: {viewStore.send(.firstDatePickerViewVisible(true))}
        )
        .padding(.top, 24)
        .padding(.horizontal, 16)

        Spacer()

        CommonHorizontalButton(
          title: "완료",
          backgroundColor: .black
        ) {
          viewStore.send(.doneButtonTapped)
        }
        .padding(.bottom, 20)
        .padding(.horizontal, 16)
      }
    }
  }
}

#Preview {
  OnboardingFirstDateView(
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
