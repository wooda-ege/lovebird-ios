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

    var yearColor: LoveBirdColors {
      switch self {
      case .anniversary:
        return LoveBirdAsset.gray05
      default:
        return LoveBirdAsset.gray07
      }
    }

    var monthOrDayColor: LoveBirdColors {
      switch self {
      case .anniversary:
        return LoveBirdAsset.gray05
      default:
        return LoveBirdAsset.gray12
      }
    }
  }

  let store: StoreOf<HomeCore>
  let diary: HomeDiary

  var body: some View {
    HStack(spacing: 12) {
      leftLineView
      dateView
      contentView
    }
  }
}

// MARK: - Child Views

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

      if diary.isMine {
        Circle()
          .fill(Color(asset: LoveBirdAsset.primary))
          .frame(width: 8, height: 8)
          .padding(.top, 41)
      } else {
        ZStack {
          Circle()
            .fill(.white)
            .frame(size: 12)

          Circle()
            .fill(Color(asset: LoveBirdAsset.secondary))
            .frame(size: 6)
        }
        .padding(.top, 39)
      }
    }
    .padding(.leading, diary.isMine ? 2 : 0)
  }

  var currentLeftLineView: some View {
    ZStack(alignment: .top) {
      VStack(alignment: .leading) {
        Rectangle()
          .fill(Color(asset: LoveBirdAsset.primary))
          .frame(width: 2, height: 40)

        Spacer()
      }

      ZStack {
        Circle()
          .stroke(Color(asset: LoveBirdAsset.primary), lineWidth: 1.2)
          .frame(size: 12)

        Circle()
          .fill(Color(asset: LoveBirdAsset.primary))
          .frame(size: 6)
      }
      .background(.white)
      .padding(.top, 39)
    }
  }

  var followingLeftLineView: some View {
    VStack {
      Circle()
        .stroke(Color(asset: LoveBirdAsset.primary), lineWidth: 1)
        .frame(size: 8)
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
            .foregroundColor(Color(asset: diary.type.monthOrDayColor))
            .font(.pretendard(size: 14, weight: .bold))

          Text(String(diary.memoryDate.day))
            .foregroundColor(Color(asset: diary.type.monthOrDayColor))
            .font(.pretendard(size: 16, weight: .regular))

          Text(String(diary.memoryDate.year))
            .foregroundColor(Color(asset: diary.type.yearColor))
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
    Group {
      if diary.isFolded {
        foldedDiaryContentView
      } else {
        unfoldedDiaryContentView
      }
    }
  }

  var foldedDiaryContentView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        Text(diary.title)
          .lineLimit(1)
          .foregroundColor(.black)
          .font(.pretendard(size: 18, weight: .bold))
          .padding(20)

        Spacer()
      }
      .background(Color(asset: LoveBirdAsset.gray03))
      .cornerRadius(12)
      .padding(.top, 37)
      .padding(.trailing, 16)
      .onTapGesture {
        viewStore.send(.diaryTitleTapped(diary))
      }
    }
  }

  var unfoldedDiaryContentView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        VStack {
          HStack {
            Text(diary.title)
              .lineLimit(1)
              .foregroundColor(Color.black)
              .font(.pretendard(size: 18, weight: .bold))
              .padding([.horizontal, .top], 20)
              .padding(.bottom, 12)

            Spacer()
          }
          .background(.white)
          .onTapGesture {
            viewStore.send(.diaryTitleTapped(diary))
          }

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

            if let urlString = diary.imageUrls.first {
              KFImage(urlString: urlString)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxHeight: 100)
                .clipped()
                .cornerRadius(4)
            }

            Spacer(minLength: 4)
          }
          .padding(.horizontal, 20)
        }
        .background(.white)
        .cornerRadius(12)
        .padding(.top, 37)
        .padding(.trailing, 16)
        .shadow(color: .black.opacity(0.08), radius: 12)
        .onTapGesture {
          viewStore.send(.diaryTapped(diary))
        }

        if viewStore.mode == .couple {
          HStack(alignment: .center, spacing: 0) {
            Spacer()

            Text("작성자")
              .foregroundColor(Color(asset: LoveBirdAsset.gray06))
              .font(.pretendard(size: 12))

            Spacer().frame(width: 8)

            Image(asset: LoveBirdAsset.icProfile)
              .changeSize(to: .init(width: 16, height: 16))
              .clipped()
              .cornerRadius(10)

            Spacer().frame(width: 4)

            Text("\(viewStore.profile?.authorName(with: diary.userId) ?? "")")
              .foregroundColor(.black)
              .font(.pretendard(size: 12))
          }
          .padding(.top, 10)
          .padding(.trailing, 16)
        }
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
