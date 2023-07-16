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
  
  enum ViewAction {
    case alertDismissed
    case emailChanged(String)
    case loginButtonTapped
    case passwordChanged(String)
    case twoFactorDismissed
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        HStack(alignment: .center) {
          Rectangle()
            .fill(Color(R.color.primary))
            .frame(width: 24, height: 24)
          Spacer()
          HStack(spacing: 16) {
            Button { viewStore.send(.searchTapped) } label: {
              Image(R.image.ic_search)
                .changeColor(to: Color(R.color.primary))
            }
            Button { viewStore.send(.searchTapped) } label: {
              Image(R.image.ic_list_bulleted)
            }
            Button { viewStore.send(.searchTapped) } label: {
              Image(R.image.ic_notification)
            }
          }
        }
        .frame(height: 44)
        .padding([.leading, .trailing], 16)
        
        Spacer()
        
        ZStack(alignment: .leading) {
          Line()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [2]))
            .frame(maxWidth: 1, maxHeight: .infinity)
            .foregroundColor(Color(R.color.primary))
            .padding(.leading, 22)
          
          VStack(alignment: .leading) {
            GeometryReader { proxy in
              Rectangle()
                .fill(Color(R.color.primary))
                .frame(width: 2, height: min(
                  UIScreen.height,
                  max(0, proxy.frame(in: .global).origin.y + viewStore.state.offsetY))
                )
                .padding(.leading, 21)
              
              Spacer()
            }
          }
          
          ReversedScrollView { point in
            viewStore.send(.offsetYChanged(point.y))
          } content: {
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 0) {
              ForEach(viewStore.diarys) { diary in
                HomeItem(store: self.store, diary: diary)
              }
              .animation(.easeInOut, value: viewStore.diarys)
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      }
    }
  }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(store: Store(initialState: Home.State(), reducer: Home()))
//    }
//}
