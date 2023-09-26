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
            asset: viewStore.page.isFisrt
                ? LoveBirdAsset.icNavigatePreviousInactive
                : LoveBirdAsset.icNavigatePreviousActive
          )
          .frame(maxWidth: .infinity, alignment: .leading)
        }

        Spacer()

        HStack {
          ForEach(Page.Onboarding.allCases, id: \.self) {
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == $0.rawValue ? Color(asset: LoveBirdAsset.primary) : Color(asset: LoveBirdAsset.green164))
          }
        }
        .frame(maxWidth: .infinity)

        Spacer()

        Group {
          if viewStore.canSkip {
            Button { viewStore.send(.skipTapped) } label: {
              Text("건너뛰기")
                .font(.pretendard(size: 16, weight: .bold))
                .foregroundColor(Color(asset: LoveBirdAsset.primary))
            }

          } else {
            Button { viewStore.send(.nextTapped) } label: {
              Image(
                asset: viewStore.page.isLast
                  ? LoveBirdAsset.icNavigateNextInactive
                  : LoveBirdAsset.icNavigateNextActive
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
