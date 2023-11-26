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
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        navigationBarView

        ZStack(alignment: .leading) {
          leftLineView
          timeLineView
        }
      }
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }

  private func lineHeight(offsetY: CGFloat) -> CGFloat {
    min(
      UIScreen.heightExceptSafeArea,
      max(0, offsetY - (UIApplication.edgeInsets.top + 44))
    )
  }
}

// MARK: - Child Views

extension HomeView {
  var navigationBarView: some View {
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
          .frame(height: lineHeight(offsetY: viewStore.state.offsetY))
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
