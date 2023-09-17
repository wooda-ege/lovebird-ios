//
//  OnboardingTabView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/09/17.
//

import ComposableArchitecture
import SwiftUI
import SwiftUIPager

struct OnboardingTabView: View {
  let store: StoreOf<OnboardingCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      HStack(alignment: .center) {
        Button { viewStore.send(.previousTapped) } label: {
          Image(
            viewStore.page.isFisrt
            ? R.image.ic_navigate_previous_inactive
            : R.image.ic_navigate_previous_active
          )
          .frame(maxWidth: .infinity, alignment: .leading)
        }

        Spacer()

        HStack {
          ForEach(Page.Onboarding.allCases, id: \.self) {
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == $0.rawValue ? Color(R.color.primary) : Color(R.color.green164))
          }
        }
        .frame(maxWidth: .infinity)

        Spacer()

        Group {
          if viewStore.canSkip {
            Button { viewStore.send(.skipTapped) } label: {
              Text("건너뛰기")
                .font(.pretendard(size: 16, weight: .bold))
                .foregroundColor(Color(R.color.primary))
            }

          } else {
            Button { viewStore.send(.nextTapped) } label: {
              Image(
                viewStore.page.isLast
                ? R.image.ic_navigate_next_inactive
                : R.image.ic_navigate_next_active
              )
            }
          }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
      }
      .background(.white)
      .frame(height: 44)
      .padding(.horizontal, 16)
    }
  }
}

//struct OnboardingTabView_Previews: PreviewProvider {
//  static var previews: some View {
//    OnboardingTabView()
//  }
//}
