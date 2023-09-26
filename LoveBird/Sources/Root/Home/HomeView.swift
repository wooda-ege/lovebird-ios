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
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        HStack(alignment: .center) {
          Image(asset: LoveBirdAsset.imgPinkbird)
            .changeSize(to: .init(width: 36, height: 36))

          Spacer()
        }
        .frame(height: 44)
        .padding(.horizontal, 12)

        // MARK: - 왼쪽 세로 선

        ZStack(alignment: .leading) {
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

          // MARK: - 타임라인

          GeometryReader { proxy in
            ScrollViewReader { scrollProxy in
              ScrollView {
                VStack {
                  Spacer(minLength: max(proxy.size.height - viewStore.contentHeight - 44, 0))
                    .scrollViewOrigin { viewStore.send(.offsetYChanged($0.y)) }

                  LazyVGrid(columns: [GridItem(.flexible())], spacing: 0) {
                    ForEach(viewStore.diaries, id: \.diaryId) { diary in
                      HomeItem(store: self.store, diary: diary)
                    }
                    // TODO: Animation 효과가 이상해서 일단 뺌
                    //                  .animation(.easeInOut, value: viewStore.diaries)
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
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
          store: Store(
            initialState: HomeState(),
            reducer: HomeCore()
          )
        )
    }
}


