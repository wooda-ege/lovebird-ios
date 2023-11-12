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
    NavigationStackStore(store.scope(state: \.path, action: { .path($0)})) {
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
    } destination: { store in
      DiaryDetailView(store: store)
    }
  }
}

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
      Line()
        .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
        .frame(maxWidth: 1, maxHeight: .infinity)
        .foregroundColor(Color(asset: LoveBirdAsset.primary))
        .padding(.leading, 22)

      VStack(alignment: .leading) {
        GeometryReader { proxy in
          Rectangle()
            .fill(Color(asset: LoveBirdAsset.primary))
            .frame(width: 2, height: min(
              UIScreen.height,
              max(0, UIScreen.height - 550 + viewStore.state.offsetY))
            )
            .padding(.leading, 21)

          Spacer()
        }
      }
    }
  }

  var timeLineView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { proxy in
        ScrollViewReader { scrollProxy in
          ScrollView {
            VStack {
              Spacer(minLength: max(proxy.size.height - viewStore.contentHeight - 44, 0))
                .scrollViewOrigin { viewStore.send(.offsetYChanged($0.y)) }

              LazyVGrid(columns: [GridItem(.flexible())], spacing: 0) {
                ForEach(viewStore.diaries, id: \.diaryId) { diary in
                  HomeItem(store: store, diary: diary)
                }
              }
              .sizeChanges {
                viewStore.send(.contentHeightChanged($0.height))
                guard let id = viewStore.diaries.last?.diaryId,
                      !viewStore.isScrolledToBottom else { return }
                scrollProxy.scrollTo(id)
                viewStore.send(.scrolledToBottom)
              }
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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
