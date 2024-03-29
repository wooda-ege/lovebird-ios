//
//  OnboardingTitleView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/09/17.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingTitleView: View {
  let store: StoreOf<OnboardingCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 12) {
        Text(viewStore.state.pageState.title)
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.pretendard(size: 20, weight: .bold))
          .foregroundColor(.black)

        Text(viewStore.state.pageState.description)
          .frame(maxWidth: .infinity, alignment: .leading)
          .font(.pretendard(size: 16, weight: .regular))
          .foregroundColor(Color(asset: LoveBirdAsset.gray07))
      }
      .padding(.leading, 16)
    }
  }
}

#Preview {
  OnboardingTitleView(
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
