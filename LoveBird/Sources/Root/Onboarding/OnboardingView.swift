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
        VStack(spacing: 24) {
          OnboardingTabView(store: self.store)

          OnboardingTitleView(store: self.store)

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
              
            case .firstDate:
              OnboardingFirstDateView(store: self.store)
            }
          }
          .allowsDragging(false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

        birthdayPickerView
        firstDatePickerView
      }
    }
  }
}

private extension OnboardingView {
  var birthdayPickerView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      CommonBottomSheetView(isOpen: viewStore.binding(
        get: \.shouldShowBirthdayPickerView, send: OnboardingAction.birthdayPickerViewVisible
      )) {
        VStack {
          DatePickerView(date: viewStore.binding(
            get: \.birth, send: OnboardingAction.birthUpdated
          ))

          HStack(spacing: 8) {
            CommonHorizontalButton(
              title: LoveBirdStrings.onboardingDateInitial,
              backgroundColor: Color(asset: LoveBirdAsset.gray05)
            ) {
              if viewStore.pageState == .birth {
                viewStore.send(.birthInitialized)
              } else {
                viewStore.send(.firstDateInitialized)
              }
            }

            CommonHorizontalButton(
              title: LoveBirdStrings.commonConfirm,
              backgroundColor: .black
            ) {
              viewStore.send(.birthdayPickerViewVisible(false))
            }
          }
          .padding(.horizontal, 16)
        }
      }
    }
  }

  var firstDatePickerView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      CommonBottomSheetView(isOpen: viewStore.binding(
        get: \.shouldShowFirstDatePickerView, send: OnboardingAction.firstDatePickerViewVisible
      )) {
        VStack {
          DatePickerView(date: viewStore.binding(
            get: \.firstDate, send: OnboardingAction.firstDateUpdated
          ))

          HStack(spacing: 8) {
            CommonHorizontalButton(
              title: LoveBirdStrings.onboardingDateInitial,
              backgroundColor: Color(asset: LoveBirdAsset.gray05)
            ) {
              if viewStore.pageState == .birth {
                viewStore.send(.birthInitialized)
              } else {
                viewStore.send(.firstDateInitialized)
              }
            }

            CommonHorizontalButton(
              title: LoveBirdStrings.commonConfirm,
              backgroundColor: .black
            ) {
              viewStore.send(.firstDatePickerViewVisible(false))
            }
          }
          .padding(.horizontal, 16)
        }
      }
    }
  }
}

#Preview {
  OnboardingView(
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
