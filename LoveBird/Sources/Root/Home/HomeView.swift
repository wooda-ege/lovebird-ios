//
//  HomeView.swift
//  wooda
//
//  Created by 황득연 on 2023/05/09.
//

import ComposableArchitecture
import SwiftUI

struct HomeView: View {
  private let store: StoreOf<HomeCore>
  @ObservedObject var viewStore: ViewStoreOf<HomeCore>

  @State private var isRefreshing = false

  init(store: StoreOf<HomeCore>) {
    self.store = store
    self.viewStore = ViewStoreOf<HomeCore>(store, observe: { $0 })
  }

  // MARK: - Body

  var body: some View {
    VStack(spacing: 0) {
      toolbarView
      ZStack {
        ZStack(alignment: .bottomLeading) {
          leftLineView
          timeLineView
        }

        if viewStore.isLinkSuccessViewShown {
          HomeLinkSuccessView(store: store)
            .padding(.horizontal, 16)
        }
      }
    }
    .onFirstAppear {
      viewStore.send(.viewAppear)
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
    LeftAlignedHStack {
      VLine(property: .timelineDotted)
        .padding(.leading, 22)

      TopAlignedVStack(alignment: .leading) {
        VLine(property: .timeline)
          .frame(height: viewStore.state.lineHeight)
          .padding(.leading, 22)
      }
    }
  }

  var timeLineView: some View {
    GeometryReader { proxy in
      TimelineScrollView {
        VStack(spacing: 0) {
          LeftAlignedHStack {
            VLine(property: .timeline)
              .frame(maxHeight: .infinity)
              .padding(.leading, 22)
          }
          .frame(maxHeight: .infinity)

          LazyVGrid(columns: [GridItem(.flexible())], spacing: 0) {
            ForEach(viewStore.diaries, id: \.diaryId) { diary in
              HomeItem(store: store, diary: diary)
            }
          }
        }
        .frame(height: proxy.size.height)
      }
      .overlay(
        VStack {
          if isRefreshing {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
              .frame(alignment: .top)
          }
        }, alignment: .bottom
      )
      .refreshable {
        viewStore.send(.refresh)
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

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
