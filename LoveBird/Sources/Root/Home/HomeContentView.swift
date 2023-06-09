//
//  HomeContentView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/27.
//

import ComposableArchitecture
import SwiftUI

struct HomeContentView: View {
  
  let store: StoreOf<HomeCore>
  let diary: Diary
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      switch self.diary.type {
      case .empty:
        HStack {
          Text("오늘 데이트 기록하기")
            .foregroundColor(Color.black)
            .font(.pretendard(size: 16, weight: .bold))
            .padding(.vertical, 18)
            .padding(.leading, 20)
          Spacer()
          Image(R.image.ic_navigate_next)
            .padding(.trailing, 20)
        }
        .background(.white)
        .cornerRadius(12)
        .padding(.top, 37)
        .padding(.trailing, 16)
        .shadow(color: .black.opacity(0.08), radius: 12)
        .onTapGesture {
          viewStore.send(.emptyDiaryTapped)
        }
      case .fold, .unfold:
        VStack(spacing: -28) {
          HStack {
            Text(diary.title)
              .lineLimit(1)
              .foregroundColor(Color.black)
              .font(.pretendard(size: 18, weight: .bold))
              .padding(20)
            Spacer()
          }
          .background(self.diary.type == .unfold ? .white : Color(R.color.gray03))
          .onTapGesture {
            viewStore.send(.diaryTitleTapped(self.diary))
          }
          
          if self.diary.type == .unfold {
            HStack(spacing: 8) {
              Image(R.image.ic_place)
                .padding(.leading, 8)
                .padding(.vertical, 5)
              Text(diary.location)
                .lineLimit(1)
                .font(.pretendard(size: 14))
                .foregroundColor(Color(R.color.gray07))
              Spacer()
            }
            .background(Color(R.color.gray03))
            .cornerRadius(4)
            .padding(20)
            
            HStack(spacing: 8) {
              Text(diary.description)
                .font(.pretendard(size: 14))
                .foregroundColor(Color.black)
                .lineLimit(3)
                .lineSpacing(6) // 적당한 값 대입.
              Spacer()
            }
            .padding(20)
          }
        }
        .background(.white)
        .cornerRadius(12)
        .padding(.top, 37)
        .padding(.trailing, 16)
        .shadow(color: self.diary.type == .unfold ? .black.opacity(0.08) : .clear, radius: 12)
        .onTapGesture {
          viewStore.send(.diaryTapped(self.diary))
        }
      case .initial:
        HStack {
          Text("D+1")
            .foregroundColor(Color(R.color.primary))
            .font(.pretendard(size: 18, weight: .bold))
          Spacer()
        }
        .padding(.leading, 2)
        .padding(.top, 20)
      case .anniversary:
        VStack {
          HStack(alignment: .top) {
            VStack {
              Text(diary.title)
                .foregroundColor(Color(R.color.gray05))
                .font(.pretendard(size: 18, weight: .bold))
                .padding(.leading, 2)
                .padding(.top, 36)
              Spacer()
            }
            Spacer()
          }
          Spacer(minLength: 44)
        }
      }
    }
    
  }
}

//struct HomeContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeContentView(diary: Diary.dummy[0])
//    }
//}
