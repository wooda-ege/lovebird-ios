//
//  DiaryDetailView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/12.
//

import ComposableArchitecture
import SwiftUI

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

            ZStack(alignment: .center) {
              Image(uiImage: UIImage(named: viewStore.diary.imgUrls.first ?? "") ?? UIImage())
                .resizable()
                .foregroundColor(.black)
                .background(Color(R.color.gray06))
                .opacity(0.7)
                .cornerRadius(10)

              Image(uiImage: UIImage(named: viewStore.diary.imgUrls.first ?? "") ?? UIImage())
                .resizable()
                .opacity(0.7)
                .saturation(0.9)
            }
            .aspectRatio(CGSize(width: 340, height: 200), contentMode: .fit)
            .padding(.horizontal, 16)

            VStack(spacing: 12) {
              Divider()
                .background(Color(R.color.gray04))

              if let place = viewStore.diary.place {
                HStack(spacing: 6) {
                  Image(R.image.ic_map)
                    .changeSize(to: .init(width: 24, height: 24))
                    .changeColor(to: .black)

                  Text(place)
                    .font(.pretendard(size: 17))

                  Spacer()
                }

                Divider()
                  .background(Color(R.color.gray04))
              }
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

//struct DiaryDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//
//    DiaryDetailView(diary: diaryMock)
//  }
//}
