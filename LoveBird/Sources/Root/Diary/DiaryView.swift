//
//  WritingDiaryView.swift
//  JsonPractice
//
//  Created by 이예은 on 2023/05/24.
//

import SwiftUI
import _PhotosUI_SwiftUI
import ComposableArchitecture

struct DiaryView: View {
  let store: StoreOf<DiaryCore>
  @FocusState var isTitleFocused: Bool
  @FocusState var isContentFocused: Bool

  init(store: StoreOf<DiaryCore>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        toolbar
        contentView
      }
      .sheet(isPresented: viewStore.binding(
        get: { $0.isImagePickerPresented },
        send: DiaryAction.setImagePickerPresented
      )) {
        LocalImagePicker(selectedImage: viewStore.binding(
          get: { $0.selectedImage },
          send: DiaryAction.selectImage
        ))
      }
    }
    .navigationBarBackButtonHidden(true)
    .padding(.top, 5)
  }
}

extension DiaryView {
  var toolbar: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      CommonToolBar(title: "일기 쓰기", hideBackButton: viewStore.type == .add, backAction: { viewStore.send(.backTapped) }) {
        Button {
          viewStore.send(.completeTapped)

        } label: {
          Text(LoveBirdStrings.commonComplete)
            .foregroundColor((viewStore.title.isEmpty || viewStore.content.isEmpty) ? Color(asset: LoveBirdAsset.green234) : Color(asset: LoveBirdAsset.primary))
            .font(.pretendard(size: 16, weight: .bold))
        }
      }
    }
  }

  var contentView: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        ZStack(alignment: .topLeading) {
          VStack(spacing: 8) {
            CommonFocusedView(isFocused: viewStore.focusedType == .date) {
              Image(asset: LoveBirdAsset.icCalendar)

              Text(viewStore.date.to(dateFormat: Date.Format.YMD))
                .foregroundColor(.black)
                .font(.pretendard(size: 17))

              Spacer()
            }
            .onTapGesture {
              viewStore.send(.focusedTypeChanged(.date))
            }

            CommonFocusedView(isFocused: viewStore.focusedType == .title) {
              let textBinding = viewStore.binding(get: \.title, send: DiaryAction.titleEdited)
              TextField("제목", text: textBinding)
                .font(.pretendard(size: 17))
                .background(.clear)
                .padding(.trailing, 32)
                .focused($isTitleFocused)
                .frame(maxWidth: .infinity, alignment: .leading)
                .showClearButton(textBinding, trailingPadding: 2)

              Spacer()
            }
            .onTapGesture {
              viewStore.send(.focusedTypeChanged(.title))
            }

            Button { viewStore.send(.placeTapped) } label: {
              CommonFocusedView(isFocused: viewStore.focusedType == .place) {
                HStack(spacing: 6) {
                  Image(asset: LoveBirdAsset.icMap)
                    .changeSize(to: .init(width: 24, height: 24))
                    .changeColor(to: Color(asset: viewStore.place.isEmpty ? LoveBirdAsset.gray06 : LoveBirdAsset.gray12))

                  if viewStore.place.isEmpty {
                    Text("장소 선택")
                      .foregroundColor(Color(asset: LoveBirdAsset.gray06))
                      .font(.pretendard(size: 17))
                  } else {
                    Text(viewStore.place)
                      .foregroundColor(.black)
                      .font(.pretendard(size: 17))
                  }
                }

                Spacer()
              }
            }

            CommonFocusedView(isFocused: viewStore.focusedType == .content) {
              VStack(spacing: 12) {
                Text("내용")
                  .font(.pretendard(size: 16))
                  .foregroundColor(Color(asset: LoveBirdAsset.gray06))
                  .frame(maxWidth: .infinity, alignment: .leading)

                TextEditor(text: viewStore.binding(get: \.content, send: DiaryAction.contentEdited))
                  .colorMultiply(Color(asset: viewStore.focusedType == .content ? LoveBirdAsset.gray01 : LoveBirdAsset.gray02))
                  .focused($isContentFocused)
                  .frame(height: 250)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.bottom, 32)
              }
            }
            .onTapGesture {
              viewStore.send(.focusedTypeChanged(.content))
            }

            Button { viewStore.send(.setImagePickerPresented(true)) } label: {
              HStack {
                if let image = Image(data: viewStore.selectedImage) {
                  image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .cornerRadius(10)
                    .clipped()
                } else {
                  Image(asset: LoveBirdAsset.imgAddImage)
                    .frame(width: 64, height: 64)
                }

                Spacer()
              }
            }
          }
          .padding(.horizontal, 16)

          if viewStore.state.showCalendarPreview {
            VStack {
              DiaryPreviewTabView(store: store)

              DiaryPreviewContentView(store: store)
            }
            .padding([.horizontal, .top], 12)
            .padding(.bottom, 20)
            .background(.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 4)
            .offset(x: 16, y: 120)
          }
        }
      }
      .background(.white)
      .onTapGesture {
        hideKeyboard()
      }
      .onChange(of: viewStore.focusedType) { type in
        hideKeyboard()
        DispatchQueue.main.async {
          isTitleFocused = type == .title
          isContentFocused = type == .content
        }
      }
    }
  }
}

#Preview {
  DiaryView(
    store: Store(
      initialState: DiaryState(),
      reducer: { DiaryCore() }
    )
  )
}
