//
//  SearchPlaceView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/24.
//

import ComposableArchitecture
import SwiftUI
import Combine

struct SearchPlaceView: View {
  let store: StoreOf<SearchPlaceCore>

  @FocusState var isFocused: Bool

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonToolBar(title: "장소 선택", backAction: { viewStore.send(.backTapped) }) {
        Button { viewStore.send(.completeTapped(viewStore.searchTerm)) } label: {
          Text("완료")
            .foregroundColor(viewStore.searchTerm.isEmpty ? Color(asset: LoveBirdAsset.green234) : Color(asset: LoveBirdAsset.primary))
            .font(.pretendard(size: 16, weight: .bold))
        }
      }

      VStack(spacing: 20) {
        let textBinding = viewStore.binding(get: \.searchTerm, send: SearchPlaceCore.Action.termEdited)
        CommonFocusedView {
          TextField(LoveBirdStrings.diaryPlaceAddressTitle, text: textBinding)
            .font(.pretendard(size: 17))
            .background(.clear)
            .padding(.trailing, 32)
            .focused($isFocused)
            .frame(maxWidth: .infinity, alignment: .leading)
            .showClearButton(textBinding, trailingPadding: 2)
        }

        List(viewStore.placeList, id:\.id) { place in
          Button {
            viewStore.send(.selectPlace(place.placeName))
          } label: {
            VStack(alignment: .leading) {
              Text(place.placeName)
                .padding(.bottom, 2)
              Text(place.addressName)
                .font(.caption)
                .foregroundColor(Color(asset: LoveBirdAsset.gray115))
            }
          }
        }
        .listStyle(.plain)
        
        Spacer()
      }
      .padding(.horizontal, 16)
    }
    .navigationBarBackButtonHidden(true)
  }
}

#Preview {
  SearchPlaceView(
    store: Store(
      initialState: SearchPlaceCore.State(),
      reducer: { SearchPlaceCore() }
    )
  )
}
