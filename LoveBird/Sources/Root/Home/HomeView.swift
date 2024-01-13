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
  
  // MARK: - Body
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        toolbarView
        
        ZStack {
          ZStack(alignment: .leading) {
            leftLineView
            timeLineView
          }
          
          if viewStore.showLinkSuccessView {
            LinkSuccessView(store: store)
              .frame(height: 308)
              .padding(.horizontal, 16)
          }
        }
      }
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }
}

// MARK: - Child Views

extension HomeView {
  var toolbarView: some View {
    HStack(alignment: .center) {
      Image(asset: LoveBirdAsset.imgPinkbird)
        .changeSize(to: .init(width: 36, height: 36))
      
      Spacer()
    }
    .frame(height: 44)
    .padding(.horizontal, 12)
  }
  
  var leftLineView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VLine(property: .timelineDotted)
        .padding(.leading, 22)
      
      VStack(alignment: .leading) {
        VLine(property: .timeline)
          .frame(height: viewStore.state.lineHeight)
          .padding(.leading, 22)
        
        Spacer()
      }
    }
  }
  
  var timeLineView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TimelineScrollView {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 0) {
          ForEach(viewStore.diaries, id: \.diaryId) { diary in
            HomeItem(store: store, diary: diary)
          }
        }
        .scrollViewOrigin(callback: { point in
          viewStore.send(.offsetYChanged(point.y))
        })
      }
    }
  }
}

#Preview {
  HomeView(
    store: Store(
      initialState: HomeState(),
      reducer: { HomeCore() }
    )
  )
}
