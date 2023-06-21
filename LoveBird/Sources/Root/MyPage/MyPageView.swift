//
//  MypageView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/28.
//

import SwiftUI

import ComposableArchitecture
import SwiftUI

struct MyPageView: View {
  let store: StoreOf<MyPageCore>
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
  }
}

//struct MyPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyPageView()
//    }
//}
