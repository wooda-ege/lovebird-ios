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
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack {
        CommonToolBar(title: "") {
          viewStore.send(.backTapped)
        } content: {
          Button {
            viewStore.send(.deleteDiary)
          } label: {
            Text("삭제")
              .foregroundColor(Color(R.color.primary))
              .font(.pretendard(size: 16, weight: .bold))
          }
        }

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
                  .foregroundColor(Color(R.color.gray07))
                  .font(.pretendard(size: 12))
                  .frame(alignment: .leading)

                Spacer()
              }
              .padding(.horizontal, 16)
            }

            if let urlString = viewStore.diary.imgUrls.first ,
               let url = URL(string: "\(urlString)") {
                VStack {
                  KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.width - 32, height: (UIScreen.width - 32) * 0.6)
                    .clipped()
                    .cornerRadius(10)
                }
                .padding(.horizontal, 16)
            }


            VStack(spacing: 12) {
              Divider()
                .background(Color(R.color.gray04))

              HStack(spacing: 6) {
                Image(R.image.ic_map)
                  .changeSize(to: .init(width: 24, height: 24))
                  .changeColor(to: .black)

                Text(viewStore.diary.place ?? "미지정")
                  .font(.pretendard(size: 17))

                Spacer()
              }

              Divider()
                .background(Color(R.color.gray04))
            }
            .padding(.horizontal, 16)

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
    .navigationBarBackButtonHidden(true)
  }
}

struct DiaryDetailView_Previews: PreviewProvider {
  static var previews: some View {
    DiaryDetailView(
      store: .init(
        initialState: DiaryDetailState(diary: .dummy),
        reducer: DiaryDetailCore()
      )
    )
  }
}
