//
//  OnboardingGenderView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/07/03.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingGenderView: View {
  
  let store: StoreOf<OnboardingCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        VStack {
          VStack(alignment: .leading) {
            ForEach(Gender.allCases, id: \.self) { gender in
              TouchableStack {
                HStack {
                  Text(R.string.localizable.onboarding_gender_female)
                    .font(.pretendard(size: 16, weight: .semiBold))
                    .foregroundColor((viewStore.gender == gender ? Color.black : Color(R.color.gray07)))
                    .padding(.leading, 36)
                  Spacer()
                  Button {
                    viewStore.send(.genderSelected(gender))
                  } label: {
                    viewStore.gender == gender ? Image(R.image.ic_checkbox_on) : Image(R.image.ic_checkbox_off)
                  }
                  .padding(.trailing, 36)
                }
              }
              .frame(height: 56)
              .background(viewStore.gender == gender ? Color.white : Color(R.color.gray02))
              .shadow(color: .black.opacity(0.08), radius: 12)
            }
          }
          .cornerRadius(12)
          .padding(.horizontal, 16)
          
          Spacer()
            .frame(height: 294)

          CommonHorizontalButton(
            title: "확인",
            backgroundColor: viewStore.gender == nil ? Color(R.color.gray05) : .black
          ) {
            viewStore.send(.nextTapped)
          }
          .padding(.horizontal, 16)
          .padding(.bottom, 20)
        }
      }
    }
  }
}

//struct OnboardingGenderView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingGenderView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
//    }
//}


