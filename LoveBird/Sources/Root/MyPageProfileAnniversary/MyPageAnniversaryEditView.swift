//
//  MyPageAnniversaryEditView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import ComposableArchitecture
import SwiftUI

struct MyPageAnniversaryEditView: View {
  let store: StoreOf<MyPageAnniversaryEditCore>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
  }
}

//struct MyPageAnniversaryEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageAnniversaryEditView()
//    }
//}
