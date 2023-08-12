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
            Image(viewStore.page.index == 0
                  ? R.image.ic_navigate_previous_active
                  : R.image.ic_navigate_previous_inactive)
            .offset(x: 16)
          }
          
          Spacer()
          
          HStack {
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == 0 ? Color(R.color.primary) : Color(R.color.green100))
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == 1 ? Color(R.color.primary) : Color(R.color.green100))
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == 2 ? Color(R.color.primary) : Color(R.color.green100))
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == 3 ? Color(R.color.primary) : Color(R.color.green100))
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == 4 ? Color(R.color.primary) : Color(R.color.green100))
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == 5 ? Color(R.color.primary) : Color(R.color.green100))
            Circle()
              .frame(width: 10, height: 10)
              .foregroundColor(viewStore.page.index == 6 ? Color(R.color.primary) : Color(R.color.green100))
          }
          
          Spacer()
          
          Button {
            viewStore.send(.nextTapped)
            self.hideKeyboard()
          } label: {
            Image(R.image.ic_navigate_next_active)
            .offset(x: -16)
          }
        }
        .frame(width: UIScreen.width, height: 44)
        
        Pager(page: viewStore.page, data: [0, 1, 2, 3, 4, 5, 6], id: \.self) { page in
          if page == 0 {
            OnboardingEmailView(store: self.store)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else if page == 1 {
            OnboardingNicknameView(store: self.store)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else if page == 2 {
            OnboardingProfileView(store: self.store)
          } else if page == 3 {
            OnboardingBirthDateView(store: self.store)
          } else if page == 4 {
            OnboardingGenderView(store: self.store)
          } else if page == 5 {
            OnboardingDateView(store: self.store)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          } else if page == 6 {
            OnboardingInvitationView(store: self.store)
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
//        OnboardingView(store: Store(initialState: OnboardingCore.State(), reducer: OnboardingCore()))
//    }
//}
