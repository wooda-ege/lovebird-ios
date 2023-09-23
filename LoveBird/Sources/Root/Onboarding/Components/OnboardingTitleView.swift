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
          .foregroundColor(Color(R.color.gray07))
      }
      .padding(.leading, 16)
    }
  }
}

struct OnboardingTitleView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingTitleView(
      store: Store(
        initialState: OnboardingState(),
        reducer: OnboardingCore()
      )
    )
  }
}
