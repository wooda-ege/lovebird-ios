//
//  HomeView.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
    let store: StoreOf<HomeCore>

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: Store(initialState: HomeCore.State(), reducer: HomeCore()))
    }
}
