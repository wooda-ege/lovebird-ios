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
    let store: StoreOf<Onboarding>
    
    struct ViewState: Equatable, Sendable {
        var page: Page
        
        init(state: Onboarding.State) {
            self.page = state.page
        }
    }
    
    var body: some View {
        WithViewStore(self.store, observe: ViewState.init) { viewStore in
            VStack {
                HStack {
                    Button { viewStore.send(.previousTapped) } label: {
                        Image(viewStore.page.index == 0 ? R.image.ic_round_navigate_previous : R.image.ic_round_navigate_previous_inactive)
                            .offset(x: 16)
                    }
                    Spacer()
                    HStack {
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color(R.color.green200))
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color(R.color.green100))
                    }
                    Spacer()
                    Button { viewStore.send(.nextTapped) } label: {
                        Image(viewStore.page.index == 1 ? R.image.ic_round_navigate_next : R.image.ic_round_navigate_next_inactive)
                            .offset(x: -16)
                    }
                }
                .frame(width: UIScreen.width, height: 44)
                
                Pager(page: viewStore.page, data: [0, 1], id: \.self) { page in
                    if page == 0 {
                        OnboardingNicknameView(store: self.store)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        OnboardingBirthView()
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
