//
//  OnboardingView.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import ComposableArchitecture
import SwiftUI
import SwiftUIPager
import Foundation

struct OnboardingView: View {
  let store: StoreOf<OnboardingCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack() {
        VStack(spacing: 0) {
          OnboardingTabView(store: self.store)
          Spacer(minLength: 24)

          OnboardingTitleView(store: self.store)
          Spacer(minLength: 48)

          Pager(page: viewStore.page, data: Page.Onboarding.allCases, id: \.self) {
            switch $0 {
            case .email:
              OnboardingEmailView(store: self.store)
            case .nickname:
              OnboardingNicknameView(store: self.store)
            case .profileImage:
              OnboardingProfileView(store: self.store)
            case .birth:
              OnboardingBirthDateView(store: self.store)
            case .gender:
              OnboardingGenderView(store: self.store)
            case .anniversary:
              OnboardingAnniversaryView(store: self.store)
            }
          }
          .allowsDragging(false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        if viewStore.showBottomSheet {
          BottomSheetView(isOpen: viewStore.binding(
            get: \.showBottomSheet,
            send: .hideBottomSheet
          )) {
            VStack {
              DatePickerView(date: viewStore.binding(get: \.birth, send: OnboardingAction.birthUpdated))
//              DatePickerView(date: viewStore.birth)

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
            }
          }
        }
      }
    }
  }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
//    }
//}
