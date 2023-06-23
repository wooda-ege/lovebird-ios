//
//  HomeItem.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeItem: View {
  
  enum ContentType {
    case empty
    case fold
    case initial
    case unfold
    case anniversary
    
    mutating func toggle() {
      self = self == .fold ? .unfold : .fold
    }
  }
  
  let store: StoreOf<HomeCore>
  let diary: Diary
  
  var body: some View {
    HStack {
      Spacer(minLength: 16)
      HomeLeftLineView(timeState: diary.timeState)
      Spacer(minLength: 11)
      VStack(alignment: .trailing) {
        Text(String(diary.month))
          .foregroundColor(Color.black)
          .font(.pretendard(size: 14, weight: .bold))
        Text(String(diary.day))
          .foregroundColor(Color.black)
          .font(.pretendard(size: 16, weight: .regular))
        Text(String(diary.year))
          .foregroundColor(Color(R.color.gray156))
          .font(.pretendard(size: 8, weight: .bold))
        Spacer()
      }
      .padding(.top, 20)
      Spacer(minLength: 12)
      HomeContentView(store: self.store, diary: diary)
    }
  }
}

//struct HomeItem_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeItem(diary: Diary.dummy[0])
//    }
//}

