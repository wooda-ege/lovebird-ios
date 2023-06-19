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
  
  init(store: StoreOf<OnboardingCore>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack {
          Button { viewStore.send(.previousTapped) } label: {
            Image(viewStore.page.isNickname
                  ? R.image.ic_navigate_previous_inactive
                  : R.image.ic_navigate_previous_active)
            .offset(x: 16)
          }
          
          Spacer()
          
          HStack {
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(Color(R.color.primary))
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(Color(viewStore.page.isNickname ? R.color.green218 : R.color.green164))
          }
          
          Spacer()
          
          Button {
            viewStore.send(.nextTapped)
            self.hideKeyboard()
          } label: {
            Image(viewStore.page.isNickname
                  ? R.image.ic_navigate_next_active
                  : R.image.ic_navigate_next_inactive)
            .offset(x: -16)
          }
        }
        .frame(width: UIScreen.width, height: 44)
        
        Pager(page: viewStore.page, data: [0, 1], id: \.self) { page in
          if page == 0 {
            OnboardingNicknameView(store: self.store)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else {
            OnboardingDateView(store: self.store)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
        .allowsDragging(false)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
      }
    }
  }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView(store: Store(initialState: Onboarding.State(), reducer: Onboarding()))
//    }
//}
