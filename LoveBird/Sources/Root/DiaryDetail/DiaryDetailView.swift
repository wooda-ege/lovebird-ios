//
//  DiaryDetailView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/12.
//

import ComposableArchitecture
import SwiftUI
import Kingfisher

struct DiaryDetailView: View {
  let store: StoreOf<DiaryDetailCore>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack {
        VStack {
          toolbar
          contentView
        }
        .overlay(ImageViewer(
          urlString: viewStore.selectedImageURLString,
          isShown: viewStore.binding(get: \.isImageViewerShown, send: DiaryDetailAction.showImageViewer)
        ))
      }
      .navigationBarBackButtonHidden(true)
    }
  }
}

extension DiaryDetailView {
  var toolbar: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      CommonToolBar(backAction: { viewStore.send(.backTapped) }) {
        Menu {
          Button { viewStore.send(.editTapped) } label: {
            Text("수정하기")
          }

          Button { viewStore.send(.deleteTapped) } label: {
            Text("삭제하기")
          }
        } label: {
          Image(asset: LoveBirdAsset.icEditDelete)
        }
      }
    }
  }

  var contentView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        VStack(spacing: 16) {
          Text(viewStore.diary.title)
            .foregroundColor(.black)
            .font(.pretendard(size: 20, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)

          if let nickname = viewStore.nickname {
            HStack {
              Text("작성자 : \(nickname)")
                .foregroundColor(Color(asset: LoveBirdAsset.gray07))
                .font(.pretendard(size: 12))

              Spacer()

              Text(viewStore.diary.memoryDate.toDate().to(dateFormat: Date.Format.YMDDotted))
                .foregroundColor(Color(asset: LoveBirdAsset.gray07))
                .font(.pretendard(size: 12))
            }
            .padding(.horizontal, 16)
          }

          if let urlString = viewStore.diary.imgUrls.first ,
             let url = URL(string: "\(urlString)") {
            VStack {
              Button { viewStore.send(.imageTapped(urlString)) } label: {
                KFImage(url)
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: UIScreen.width - 32, height: (UIScreen.width - 32) * 0.6)
                  .clipped()
                  .cornerRadius(10)
              }
            }
            .padding(.horizontal, 16)
          }

          if let place = viewStore.diary.place {
            VStack(spacing: 12) {
              Divider()
                .background(Color(asset: LoveBirdAsset.gray04))

              HStack(spacing: 6) {
                Image(asset: LoveBirdAsset.icMap)
                  .changeSize(to: .init(width: 24, height: 24))
                  .changeColor(to: .black)

                Text(place)
                  .font(.pretendard(size: 17))

                Spacer()
              }

              Divider()
                .background(Color(asset: LoveBirdAsset.gray04))
            }
            .padding(.horizontal, 16)
          } else {
            Divider()
              .background(Color(asset: LoveBirdAsset.gray04))
              .padding(.horizontal, 16)
          }

          HStack {
            Text(viewStore.diary.content)
              .font(.pretendard(size: 16))

            Spacer()
          }
          .padding(.horizontal, 16)

          Spacer()
        }
      }
    }
  }
}

#Preview {
  DiaryDetailView(
    store: .init(
      initialState: DiaryDetailState(diary: .dummy),
      reducer: { DiaryDetailCore() }
    )
  )
}
