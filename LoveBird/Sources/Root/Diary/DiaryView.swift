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
  @StateObject private var keyboardResponder = KeyboardResponder()
  init(store: StoreOf<DiaryCore>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        ScrollView {
          VStack {
            DiarySelectCalenderButton()
            
            ZStack(alignment: .leading) {
              if viewStore.title.isEmpty {
                Text(R.string.localizable.diary_title)
                  .foregroundColor(Color(R.color.gray122))
              }
              
              TextField(String(resource: R.string.localizable.diary_title), text: viewStore.binding(get: \.title, send: DiaryCore.Action.titleLabelTapped)
              )
            }
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color.clear)
            )
            .padding([.top, .bottom], 10)
            .padding(.leading, 15)
            .frame(height: 44)
            .background(Color(R.color.gray231))
            .textFieldStyle(.plain)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(String(resource: R.string.localizable.diary_note))
            .navigationBarItems(trailing: Button(String(resource: R.string.localizable.complete_text)) {
              viewStore.send(.completeButtonTapped)
            })
            .cornerRadius(10)
            
            NavigationLink(destination: SearchPlaceView(store: Store(initialState: SearchPlaceCore.State(), reducer: SearchPlaceCore()))
              .padding(.top, 20)
              .padding(.bottom, 10)
              .padding([.leading, .trailing], 15)
            ) {
              ZStack(alignment: .center) {
                viewStore.place == String(resource: R.string.localizable.diary_select_place) ? DiarySelectPlaceButton(title: viewStore.place)
                  .foregroundColor(Color(R.color.gray122)) : DiarySelectPlaceButton(title: viewStore.place)
                  .foregroundColor(.black)
              }
              .padding(.top, 5)
              .padding(.bottom, 8)
            }
            
            ZStack(alignment: .topLeading) {
              TextEditor(text: viewStore.binding(get: \.text, send: DiaryCore.Action.textDidEditting))
                .foregroundColor(.black)
                .colorMultiply(Color(R.color.gray231))
                .frame(height: keyboardResponder.currentHeight == 0 ? 332 : 320)
                .lineSpacing(5)
                .cornerRadius(10)
              
              if viewStore.state.text.isEmpty {
                Text(R.string.localizable.diary_edit_text)
                  .foregroundColor(Color(R.color.gray122))
                  .padding(.top, 10)
                  .padding(.leading, 10)
              }
            }
            
            // 예은::ImagePickerView 아예 바꿔야함
            // ImagePickerView(image: $)
            //   .padding(.top, 10)
        
          }
          .navigationBarBackButtonHidden(true)
          .padding(.top, 10)
          .padding([.leading, .trailing], 16)
        }
      }
      .padding(.bottom, keyboardResponder.currentHeight == 0 ? 0 : keyboardResponder.currentHeight + 524 - UIScreen.main.bounds.height)
      .onAppear {
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
      }
    }
    .padding(.top, 5)
  }
}

struct WritingDiaryView_Previews: PreviewProvider {
  static var previews: some View {
    DiaryView(store: Store(initialState: DiaryCore.State(), reducer: DiaryCore()))
  }
}

