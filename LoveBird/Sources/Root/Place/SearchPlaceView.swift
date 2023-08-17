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
  @Environment(\.presentationMode) var presentationMode
  
  @Dependency(\.apiClient) var apiClient
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack() {
        TextField(String(resource: R.string.localizable.diary_place_address_title), text: viewStore.binding(get: \.searchTerm, send: SearchPlaceCore.Action.textFieldDidEditting))
          .keyboardType(.webSearch)
          .padding(.vertical, 10)
          .padding(.leading, 12)
          .background(Color(R.color.gray02))
          .cornerRadius(10)
          .navigationTitle(String(resource: R.string.localizable.diary_select_place))
          .navigationBarItems(leading: BackButton(), trailing: CompleteButton())
          .navigationBarBackButtonHidden(true)
        
//        if viewStore.state.searchTerm.isEmpty {
//          Text(R.string.localizable.diary_place_address_title)
//            .foregroundColor(Color(R.color.gray06))
//        }
      }
      .padding(.top, 20)
      .padding(.bottom, 10)
      .padding(.horizontal, 15)
      .onAppear {
        viewStore.send(.viewDidLoad)
      }
      .foregroundColor(Color(R.color.gray06))
      
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
            print("search error!")
          }
        }
        viewStore.send(.textFieldDidEditting(placeTerm))
      }
      Spacer()
    }
  }
}

struct SearchPlaceView_Previews: PreviewProvider {
  static var previews: some View {
    SearchPlaceView(store: Store(initialState: SearchPlaceCore.State(), reducer: SearchPlaceCore()))
  }
}
