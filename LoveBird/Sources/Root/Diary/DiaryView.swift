//
//  DiaryView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import ComposableArchitecture
import SwiftUI

struct DiaryView: View {
  let store: StoreOf<DiaryCore>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
  }
}

//struct DiaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiaryView()
//    }
//}
