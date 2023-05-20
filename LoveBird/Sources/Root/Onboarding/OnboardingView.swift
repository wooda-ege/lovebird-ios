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
    @StateObject var page: Page = .first()
    
    var body: some View {
        VStack {
            HStack {
                Image(page.index == 0 ? R.image.ic_round_navigate_previous : R.image.ic_round_navigate_previous_inactive)
                    .offset(x: 16)
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
                Image(page.index == 1 ? R.image.ic_round_navigate_next : R.image.ic_round_navigate_next_inactive)
                    .offset(x: -16)
            }
            .frame(width: UIScreen.width, height: 44)
            
            Pager(page: page, data: [1, 2], id: \.self) { page in
                if page == 1 {
                    OnboardingNicknameView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    OnboardingNicknameView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView(store: Store(initialState: Onboarding.State(), reducer: Onboarding()))
//    }
//}
