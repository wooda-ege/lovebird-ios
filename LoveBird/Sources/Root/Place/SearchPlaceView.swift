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
  @Dependency(\.apiClient) var apiClient
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonToolBar(title: "장소 선택") {
        viewStore.send(.backTapped)
      } content: {
        Button {
          viewStore.send(.completeTapped(viewStore.searchTerm))
        } label: {
          Text("완료")
            .foregroundColor(viewStore.searchTerm.isEmpty ? Color(R.color.green234) : Color(R.color.primary))
            .font(.pretendard(size: 16, weight: .bold))
        }
      }

      VStack(spacing: 20) {
        let textBinding = viewStore.binding(get: \.searchTerm, send: SearchPlaceCore.Action.textFieldDidEditting)
        CommonFocusedView {
          TextField(String(resource: R.string.localizable.diary_place_address_title), text: textBinding)
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
                .foregroundColor(Color(R.color.gray115))
            }
          }
        }
        .listStyle(.plain)
        .onChange(of: viewStore.searchTerm) { placeTerm in
          Task {
            do {
              let places = try await apiClient.requestKakaoMap(.searchKakaoMap(searchTerm: placeTerm)) as [PlaceInfo]
              viewStore.send(.changePlaceInfo(places))
            } catch {
              print(error)
            }
          }
          viewStore.send(.textFieldDidEditting(placeTerm))
        }
        Spacer()
      }
      .padding(.horizontal, 16)
    }
    .navigationBarBackButtonHidden(true)
  }
}

struct SearchPlaceView_Previews: PreviewProvider {
  static var previews: some View {
    SearchPlaceView(
      store: Store(
        initialState: SearchPlaceCore.State(),
        reducer: SearchPlaceCore()
      )
    )
  }
}
