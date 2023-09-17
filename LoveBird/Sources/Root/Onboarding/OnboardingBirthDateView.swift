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
      ZStack {
        VStack {
          OnboardingDateView(date: viewStore.birth, onTap: {
            viewStore.send(.showBottomSheet)
          })
          .frame(maxWidth: .infinity)
          .padding(.horizontal, 16)

          Spacer()

          CommonHorizontalButton(title: "확인") {
            viewStore.send(.nextButtonTapped)
          }
          .padding(.horizontal, 16)
          .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
        }

        if viewStore.showBottomSheet {
          BottomSheetView(isOpen: viewStore.binding(
            get: \.showBottomSheet,
            send: .hideBottomSheet
          )) {
            VStack {
              DatePickerView(date: viewStore.birth) {
                viewStore.send(.birthUpdated($0))
              }

              HStack(spacing: 8) {
                CommonHorizontalButton(
                  title: String(resource: R.string.localizable.onboarding_date_initial),
                  backgroundColor: Color(R.color.gray05)
                ) {
                  viewStore.send(.birthInitialized)
                }

                CommonHorizontalButton(
                  title: String(resource: R.string.localizable.common_confirm),
                  backgroundColor: .black
                ) {
                  viewStore.send(.hideBottomSheet)
                }
              }
              .padding(.horizontal, 16)
              .padding(.bottom, 100 + UIApplication.edgeInsets.bottom)
            }
          }
        }
      }
      .background(.white)
    }
  }
}

struct OnboardingBirthDateView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingBirthDateView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
  }
}

