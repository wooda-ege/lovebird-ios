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
    WithViewStore(self.store) { viewStore in
      ZStack {
        VStack {
          HStack(alignment: .center, spacing: 8) {
            Text(String(viewStore.birthdateYear))
              .font(.pretendard(size: 18))
            Text("/")
              .font(.pretendard(size: 18))
              .foregroundColor(Color(R.color.gray05))
            Text(String(viewStore.birthdateMonth))
              .font(.pretendard(size: 18))
            Text("/")
              .font(.pretendard(size: 18))
              .foregroundColor(Color(R.color.gray05))
            Text(String(viewStore.birthdateDay))
              .font(.pretendard(size: 18))
          }
          .frame(width: UIScreen.width - 32, height: 56)
          .contentShape(Rectangle())
          .roundedBackground(cornerRadius: 12, color: Color(R.color.primary))
          .onTapGesture {
            viewStore.send(.showBottomSheet)
          }
          
          Spacer()
          
          SkipDateButtonView {
            viewStore.send(.skipBirthdate)
          } confirmAction: {
            viewStore.send(.selectBirthDate)
          }
          .background(.white)
          .cornerRadius(12)
          .padding(.horizontal, 10)
          .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
        }
        .background(.white)
        
        if viewStore.showBottomSheet {
          BottomSheetView(isOpen: viewStore.binding(
            get: \.showBottomSheet,
            send: .hideBottomSheet
          )) {
            VStack {
              BirthDatePickerView(viewStore: viewStore)
              
              HStack(spacing: 8) {
                Button(action: {
                  viewStore.send(.birthdateInitialied)
                }) {
                  Text(R.string.localizable.onboarding_date_initial)
                    .font(.pretendard(size: 16, weight: .semiBold))
                    .frame(maxWidth: .infinity, maxHeight: 56)
                    .background(Color(R.color.gray05))
                    .cornerRadius(12)
                }
                
                Button(action: {
                  viewStore.send(.hideBottomSheet)
                }) {
                  Text(R.string.localizable.common_confirm)
                    .font(.pretendard(size: 16, weight: .semiBold))
                    .frame(maxWidth: .infinity, maxHeight: 56)
                    .background(.black)
                    .cornerRadius(12)
                }
              }
              .foregroundColor(.white)
              .padding(.horizontal, 16)
              .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
            }
          }
        }
      }
    }
  }
}

struct OnboardingBirthDateView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingBirthDateView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
    }
}

