//
//  OnboardingAnniversaryView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingAnniversaryView: View {
  
  let store: StoreOf<OnboardingCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
//        VStack {
//          HStack(alignment: .center, spacing: 8) {
//            Text(String(viewStore.anniversary.year))
//              .font(.pretendard(size: 18))
//            Text("/")
//              .font(.pretendard(size: 18))
//              .foregroundColor(Color(R.color.gray05))
//            Text(String(viewStore.firstdateMonth))
//              .font(.pretendard(size: 18))
//            Text("/")
//              .font(.pretendard(size: 18))
//              .foregroundColor(Color(R.color.gray05))
//            Text(String(viewStore.firstdateDay))
//              .font(.pretendard(size: 18))
//          }
//          .frame(width: UIScreen.width - 32, height: 56)
//          .contentShape(Rectangle())
//          .roundedBackground(cornerRadius: 12, color: Color(R.color.primary))
//          .onTapGesture {
//            viewStore.send(.showBottomSheet)
//          }
//
//          Spacer()
//
//          CommonHorizontalButton(
//            title: "확인",
//            backgroundColor: .black
//          ) {
//            viewStore.send(.doneButtonTapped)
//          }
//          .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
//
//          if viewStore.showBottomSheet {
//            BottomSheetView(isOpen: viewStore.binding(get: \.showBottomSheet, send: .hideBottomSheet)) {
//              VStack {
//                DatePickerView(viewStore: viewStore)
//
//                HStack(spacing: 8) {
//                  Button(action: {
//                    viewStore.send(.dateInitialied)
//                  }) {
//                    Text(R.string.localizable.onboarding_date_initial)
//                      .font(.pretendard(size: 16, weight: .semiBold))
//                      .frame(maxWidth: .infinity, maxHeight: 56)
//                      .background(Color(R.color.gray05))
//                      .cornerRadius(12)
//                  }
//
//                  Button(action: {
//                    viewStore.send(.hideBottomSheet)
//                  }) {
//                    Text(R.string.localizable.common_next)
//                      .font(.pretendard(size: 16, weight: .semiBold))
//                      .frame(maxWidth: .infinity, maxHeight: 56)
//                      .background(.black)
//                      .cornerRadius(12)
//                  }
//                }
//                .foregroundColor(.white)
//                .padding(.horizontal, 16)
//                .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
//              }
//            }
//          }
//        }
      }
    }
  }
}

//struct OnboardingDateView_Previews: PreviewProvider {
//    static var previews: some View {
//      OnboardingDateView(store: .init(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
//    }
//}
