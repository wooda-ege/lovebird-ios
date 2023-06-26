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
  
  enum Constant {
    static var placeholder = String(resource: R.string.localizable.diary_place_address_title)
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack(spacing: 10) {
        TextField(Constant.placeholder, text: viewStore.binding(get: \.searchTerm, send: SearchPlaceCore.Action.textFieldDidEditting))
          .keyboardType(.webSearch)
          .padding(.top, 10)
          .padding(.leading, 12)
          .padding(.bottom, 10)
          .background(Color(R.color.gray231))
          .cornerRadius(10)
          .navigationTitle(String(resource: R.string.localizable.diary_select_place))
          .navigationBarItems(leading: BackButton(), trailing: CompleteButton()
            .onTapGesture {
              viewStore.send(.completeButtonTapped)
              Constant.placeholder = String(resource: R.string.localizable.diary_place_address_title)
            })
          .navigationBarBackButtonHidden(true)
      }
      
      List(viewStore.placeList, id:\.id) { place in
        Button {
          Constant.placeholder = place.placeName
          viewStore.send(.completeButtonTapped)
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
        viewStore.send(.textFieldDidEditting(placeTerm))
      }
      Spacer()
    }
  }
}

//struct SearchPlaceView_Previews: PreviewProvider {
//  static var previews: some View {
//    SearchPlaceView()
//  }
//}
