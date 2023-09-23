//
//  HomeContentView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/27.
//

import ComposableArchitecture
import SwiftUI
import Kingfisher

struct HomeContentView: View {
  let store: StoreOf<HomeCore>
  let diary: Diary
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
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
          viewStore.send(.todoDiaryTapped)
        }

      case .diary:
        VStack {
          HStack {
            Text(diary.title)
              .lineLimit(1)
              .foregroundColor(Color.black)
              .font(.pretendard(size: 18, weight: .bold))
              .padding([.horizontal, .top], 20)
              .padding(.bottom, self.diary.isFolded ? 20 : 12)

            Spacer()
          }
          .background(self.diary.isFolded ? Color(R.color.gray03) : .white)
          .onTapGesture {
            viewStore.send(.diaryTitleTapped(self.diary))
          }
          
          if !self.diary.isFolded {
            NavigationLinkStore(
              self.store.scope(state: \.$diaryDetail, action: HomeAction.diaryDetail)
            ) {
              viewStore.send(.diaryTapped(self.diary))
            } destination: { store in
              DiaryDetailView(store: store)
            } label: {
              VStack(spacing: 12) {
                if let place = self.diary.place, place.isNotEmpty {
                  HStack(spacing: 8) {
                    Image(R.image.ic_place)
                      .padding(.leading, 8)
                      .padding(.vertical, 5)

                    Text(place)
                      .lineLimit(1)
                      .font(.pretendard(size: 14))
                      .foregroundColor(Color(R.color.gray07))

                    Spacer()
                  }
                  .background(Color(R.color.gray03))
                  .cornerRadius(4)
                }

                HStack(spacing: 8) {
                  Text(self.diary.content)
                    .font(.pretendard(size: 14))
                    .foregroundColor(Color.black)
                    .font(.pretendard(size: 18, weight: .bold))

                  Spacer()
                }

                if let urlString = self.diary.imgUrls.first, let url = URL(string: urlString) {
                  KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
                    .cornerRadius(4)
                }

                Spacer(minLength: 4)
              }
              .padding(.horizontal, 20)
            }
          }
        }
        .background(.white)
        .cornerRadius(12)
        .padding(.top, 37)
        .padding(.trailing, 16)
        .shadow(color: self.diary.isFolded ? .clear : .black.opacity(0.08), radius: 12)
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
        .padding(.bottom, 44)
      }
    }
  }
}

struct HomeContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeContentView(
      store: .init(
        initialState: HomeState(),
        reducer: HomeCore()
      ),
      diary: .dummy
    )
  }
}
