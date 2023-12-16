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
            viewStore.send(.optionButtonTapped)
          } label: {
            ZStack(alignment: .trailing) {
              Image(asset: LoveBirdAsset.icEditDelete)
                .resizable()
                .frame(width: 24, height: 24)
              
              if viewStore.state.showBottomSheet {
                VStack(alignment: .leading) {
                  Text("수정하기")
                    .onTapGesture {
                      viewStore.send(.editButtonTapped)
                    }
                  Divider()
                  Text("삭제하기")
                    .onTapGesture {
                      viewStore.send(.deleteButtonTapped)
                    }
                }
                .foregroundColor(.black)
                .padding(10)
                .background(.white)
                .cornerRadius(12)
                .offset(x: 2, y: 58)
              }
            }
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
                  .foregroundColor(Color(asset: LoveBirdAsset.gray07))
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
                .background(Color(asset: LoveBirdAsset.gray04))

              HStack(spacing: 6) {
                Image(asset: LoveBirdAsset.icMap)
                  .changeSize(to: .init(width: 24, height: 24))
                  .changeColor(to: .black)

                Text(viewStore.diary.place ?? "미지정")
                  .font(.pretendard(size: 17))

                Spacer()
              }

              Divider()
                .background(Color(asset: LoveBirdAsset.gray04))
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

#Preview {
  DiaryDetailView(
    store: .init(
      initialState: DiaryDetailState(diary: .dummy),
      reducer: { DiaryDetailCore() }
    )
  )
}
