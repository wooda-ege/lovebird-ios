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
  @Binding var placeSelection: String
  @Environment(\.presentationMode) var presentationMode
//
  enum Constant {
    static var placeholder = " 장소, 주소를 입력해주세요."
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack(spacing: 10) {
        TextField(Constant.placeholder, text: viewStore.binding(get: \.searchTerm, send: SearchPlaceCore.SearchPlaceAction.textFieldDidEditting))
          .keyboardType(.webSearch)
          .padding(.top, 10)
          .padding(.leading, 12)
          .padding(.bottom, 10)
          .background(Color(uiColor: .secondarySystemBackground))
          .cornerRadius(10)
          .navigationTitle("장소 선택")
          .navigationBarItems(leading: BackButton(), trailing: CompleteButton()
            .onTapGesture {
              viewStore.send(.completeButtonTapped)
              Constant.placeholder = " 장소, 주소를 입력해주세요."
            })
          .navigationBarBackButtonHidden(true)
      }
      
      List(viewStore.placeList, id:\.id) { place in
        Button {
          placeSelection = place.placeName
          Constant.placeholder = place.placeName
          viewStore.send(.completeButtonTapped)
        } label: {
          VStack(alignment: .leading) {
            Text(place.placeName)
              .padding(.bottom, 2)
            Text(place.addressName)
              .font(.caption)
              .foregroundColor(.gray)
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
