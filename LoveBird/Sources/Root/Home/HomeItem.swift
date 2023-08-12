//
//  HomeItem.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/25.
//

import ComposableArchitecture
import SwiftUI

struct HomeItem: View {
  
  enum ContentType: Decodable, Encodable, Sendable {
    case empty
    case diary
    case initial
    case anniversary
  }
  
  let store: StoreOf<HomeCore>
  let diary: Diary
  
  var body: some View {
    HStack {
      Spacer(minLength: 16)

      HomeLeftLineView(timeState: diary.timeState ?? .previous)

      Spacer(minLength: 11)

      VStack(alignment: .trailing) {
        Text(String(diary.memoryDate.month))
          .foregroundColor(Color.black)
          .font(.pretendard(size: 14, weight: .bold))

        Text(String(diary.memoryDate.day))
          .foregroundColor(Color.black)
          .font(.pretendard(size: 16, weight: .regular))

        Text(String(diary.memoryDate.year))
          .foregroundColor(Color(R.color.gray07))
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

