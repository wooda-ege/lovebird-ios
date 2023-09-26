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
                  Text(gender.description)
                    .font(.pretendard(size: 18, weight: viewStore.gender == gender ? .bold : .regular))
                    .foregroundColor((viewStore.gender == gender ? Color.black : Color(asset: LoveBirdAsset.gray07)))
                    .padding(.leading, 20)

                  Spacer()

                  Image(asset: viewStore.gender == gender ? LoveBirdAsset.icCheckboxOn : LoveBirdAsset.icCheckboxOff)
                    .padding(.trailing, 20)
                }
              }
              .frame(height: 56)
              .background(viewStore.gender == gender ? Color.white : Color(asset: LoveBirdAsset.gray02))
              .cornerRadius(12)
              .shadow(color: viewStore.gender == gender ? .black.opacity(0.08) : .clear, radius: 12)
              .onTapGesture {
                viewStore.send(.genderSelected(gender))
              }
            }
          }
          .padding(.top, 24)
          .padding(.horizontal, 16)
          
          Spacer()

          CommonHorizontalButton(
            title: "다음",
            backgroundColor: viewStore.gender == nil ? Color(asset: LoveBirdAsset.gray05) : .black
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

struct OnboardingGenderView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingGenderView(
          store: Store(
            initialState: OnboardingState(),
            reducer: OnboardingCore()
          )
        )
    }
}


