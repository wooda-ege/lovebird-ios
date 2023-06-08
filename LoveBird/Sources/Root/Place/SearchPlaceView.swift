//
//  SearchPlaceView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/05/24.
//

import ComposableArchitecture
import SwiftUI

struct SearchPlaceView: View {
  let store: StoreOf<SearchPlaceCore>
  @Environment(\.presentationMode) var presentationMode
//  @Binding var placeSelection: String
  
  enum Constant {
    static let placeholder = " 장소, 주소를 입력해주세요."
  }
  
//  @State var placeList: [PlaceInfo] = []
//  @State private var searchTerm = ""
  
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
                SearchPlaceCore.SearchPlaceAction.completeButtonTapped
            })
          .navigationBarBackButtonHidden(true)
      }
      List(viewStore.placeList, id:\.id) { place in
        PlaceView(place: place.placeName) {
          viewStore.send(.selectPlace(place.placeName))
        }
      }
      .listStyle(.plain)
      //      .scrollContentBackground(.hidden)
      .onChange(of: viewStore.searchTerm) { newValue in
        let api = SearchPlaceAPI()
        let urlRequest: URLRequest = api.configureRequest(query: newValue)
        
        NetworkManager.shared.execute(urlRequest: urlRequest) { placeInfo in
          viewStore.send(.changePlaceInfo(placeInfo))
        }
      }
      Spacer()
    }
  }
}

//struct SearchPlaceView_Previews: PreviewProvider {
//  static var previews: some View {
//    SearchPlaceView(placeSelection: )
//  }
//}

struct PlaceView: View {
  var place: String
  let onClick: () -> Void
  
  var body: some View {
    VStack {
      Text(place)
    }
    .onTapGesture {
      onClick()
    }
  }
}


