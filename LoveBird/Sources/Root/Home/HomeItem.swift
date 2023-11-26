//
//  HomeItem.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/25.
//

import ComposableArchitecture
import SwiftUI
import Kingfisher

struct HomeItem: View {

  enum ContentType: Codable {
    case empty
    case diary
    case initial
    case anniversary
  }

  let store: StoreOf<HomeCore>
  let diary: Diary

  var body: some View {
    HStack(spacing: 12) {
      leftLineView
      dateView
      contentView
    }
  }
}

// MARK: - UI Componenets

extension HomeItem {

  // MARK: LeftLine View

  var leftLineView: some View {
    Group {
      switch diary.timeState {
      case .previous:
        self.previousLeftLineView

      case .current:
        self.currentLeftLineView

      case .following:
        self.followingLeftLineView

      }
    }
    .padding(.leading, 16)
  }

  var previousLeftLineView: some View {
    ZStack(alignment: .top) {
      Rectangle()
        .fill(Color(asset: LoveBirdAsset.primary))
        .frame(maxWidth: 2, maxHeight: .infinity)
      Circle()
        .fill(Color(asset: LoveBirdAsset.primary))
        .frame(width: 8, height: 8)
        .padding(.top, 41)
    }
    .padding(.leading, 2)
  }

  var currentLeftLineView: some View {
    ZStack(alignment: .top) {
      VStack(alignment: .leading, spacing: 0) {
        Rectangle()
          .fill(Color(asset: LoveBirdAsset.primary))
          .frame(width: 2, height: 40)
        Spacer()
      }.frame(width: 2)
      ZStack {
        Circle()
          .stroke(Color(asset: LoveBirdAsset.primary), lineWidth: 1.2)
          .frame(width: 12, height: 12)
        Circle()
          .fill(Color(asset: LoveBirdAsset.primary))
          .frame(width: 6, height: 6)
      }
      .background(.white)
      .padding(.top, 39)
    }
  }

  var followingLeftLineView: some View {
    VStack {
      Circle()
        .stroke(Color(asset: LoveBirdAsset.primary), lineWidth: 1)
        .frame(width: 8, height: 8)
        .background(.white)
        .padding(.top, 41)
      Spacer()
    }
    .padding(.leading, 2)
  }

  // MARK: Date View

  var dateView: some View {
    Group {
      if diary.isTimelineDateShown {
        VStack(alignment: .trailing) {
          Text(String(diary.memoryDate.month))
            .foregroundColor(diary.type == .anniversary ? Color(asset: LoveBirdAsset.gray05) : Color.black)
            .font(.pretendard(size: 14, weight: .bold))

          Text(String(diary.memoryDate.day))
            .foregroundColor(diary.type == .anniversary ? Color(asset: LoveBirdAsset.gray05) : Color.black)
            .font(.pretendard(size: 16, weight: .regular))

          Text(String(diary.memoryDate.year))
            .foregroundColor(diary.type == .anniversary ? Color(asset: LoveBirdAsset.gray05) : Color(asset: LoveBirdAsset.gray07))
            .font(.pretendard(size: 8, weight: .bold))

          Spacer()
        }
        .padding(.top, 20)
      } else {
        // Date를 보여줄때와 같은 Width를 같게 하기 위함.
        VStack {
          Text("2023")
            .foregroundColor(.clear)
            .font(.pretendard(size: 8, weight: .bold))
        }
      }
    }
  }

  // MARK: ContentView

  var contentView: some View {
    Group {
      switch diary.type {
      case .empty:
        emptyContentView

      case .diary:
        diaryContentView

      case .initial:
        initialContentView

      case .anniversary:
        anniversaryContentView
      }
    }
  }

  var emptyContentView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        Text("오늘 데이트 기록하기")
          .foregroundColor(Color.black)
          .font(.pretendard(size: 16, weight: .bold))
          .padding(.vertical, 18)
          .padding(.leading, 20)

        Spacer()

        Image(asset: LoveBirdAsset.icNavigateNext)
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
    }
  }
  
  var diaryContentView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        HStack {
          Text(diary.title)
            .lineLimit(1)
            .foregroundColor(Color.black)
            .font(.pretendard(size: 18, weight: .bold))
            .padding([.horizontal, .top], 20)
            .padding(.bottom, diary.isFolded ? 20 : 12)

          Spacer()
        }
        .background(diary.isFolded ? Color(asset: LoveBirdAsset.gray03) : .white)
        .onTapGesture {
          viewStore.send(.diaryTitleTapped(diary))
        }

        if !diary.isFolded {
            VStack(spacing: 12) {
              if let place = diary.place, place.isNotEmpty {
                HStack(spacing: 8) {
                  Image(asset: LoveBirdAsset.icPlace)
                    .padding(.leading, 8)
                    .padding(.vertical, 5)

                  Text(place)
                    .lineLimit(1)
                    .font(.pretendard(size: 14))
                    .foregroundColor(Color(asset: LoveBirdAsset.gray07))

                  Spacer()
                }
                .background(Color(asset: LoveBirdAsset.gray03))
                .cornerRadius(4)
              }

              HStack(spacing: 8) {
                Text(diary.content)
                  .font(.pretendard(size: 14))
                  .foregroundColor(Color.black)
                  .font(.pretendard(size: 18, weight: .bold))

                Spacer()
              }

              if let urlString = diary.imgUrls.first, let url = URL(string: urlString) {
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
      .background(.white)
      .cornerRadius(12)
      .padding(.top, 37)
      .padding(.trailing, 16)
      .shadow(color: diary.isFolded ? .clear : .black.opacity(0.08), radius: 12)
      .onTapGesture {
        viewStore.send(.diaryTapped(diary))
      }
    }
  }

  var initialContentView: some View {
    HStack {
      Text("D+1")
        .foregroundColor(Color(asset: LoveBirdAsset.primary))
        .font(.pretendard(size: 18, weight: .bold))

      Spacer()
    }
    .padding(.leading, 2)
    .padding(.top, 20)
  }

  var anniversaryContentView: some View {
    HStack(alignment: .top) {
      VStack {
        Text(diary.title)
          .foregroundColor(Color(asset: LoveBirdAsset.gray05))
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

#Preview {
  HomeItem(
    store: .init(
      initialState: HomeState(),
      reducer: { HomeCore() }
    ),
    diary: .dummy
  )
}
