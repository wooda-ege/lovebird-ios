//
//  OnboardingView.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import ComposableArchitecture
import SwiftUI

struct OnboardingView: View {
    let store: StoreOf<Onboarding>

    var body: some View {
        VStack {
            HStack {
                Image("")
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(store: Store(initialState: Onboarding.State(), reducer: Onboarding()))
    }
}
