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
  @State var image: UIImage? = nil
  @StateObject private var keyboardResponder = KeyboardResponder()
  
  init(store: StoreOf<DiaryCore>) {
    self.store = store
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        ScrollView {
          ZStack(alignment: .topLeading) {
            VStack {
              viewStore.date == String(resource: R.string.localizable.calendar_date) ? DiarySelectCalenderButton(title: viewStore.date)
                .foregroundColor(Color(R.color.gray06)) : DiarySelectCalenderButton(title: viewStore.date)
                .foregroundColor(.black)
            }
            .onTapGesture {
              viewStore.send(.hideDateView)
            }
            
            if viewStore.state.showCalendarPreview {
              VStack {
                //                CalendarPreviewTabView(viewStore: viewStore)
                
                CalendarPreviewContentView(store: self.store.scope(state: \.calendarDate, action: DiaryCore.Action.calendarDate))
              }
              .padding([.horizontal, .top], 12)
              .padding(.bottom, 20)
              .background(.white)
              .cornerRadius(12)
              .shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 4)
              .offset(x: 16, y: 64)
            }
          }
          
          ZStack(alignment: .leading) {
            if viewStore.title.isEmpty {
              Text(R.string.localizable.diary_title)
                .foregroundColor(Color(R.color.gray06))
            }
            
            TextField(String(resource: R.string.localizable.diary_title), text: viewStore.binding(get: \.title, send: DiaryCore.Action.titleLabelTapped)
            )
          }
          .overlay(
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color.clear)
          )
          .padding(.vertical, 10)
          .padding(.leading, 15)
          .frame(height: 44)
          .foregroundColor(.black)
          .background(Color(R.color.gray02))
          .textFieldStyle(.plain)
          .navigationBarTitleDisplayMode(.inline)
          .navigationTitle(String(resource: R.string.localizable.diary_note))
          .navigationBarItems(trailing: Button(String(resource: R.string.localizable.complete_text)) {
            viewStore.send(.completeButtonTapped)
          })
          .cornerRadius(10)
          
          NavigationLink(destination: SearchPlaceView(store: self.store.scope(state: \.searchPlace, action: DiaryCore.Action.searchPlace)))
          {
            ZStack(alignment: .center) {
              viewStore.place == String(resource: R.string.localizable.diary_select_place) ? DiarySelectPlaceButton(title: viewStore.place)
                .foregroundColor(Color(R.color.gray06)) : DiarySelectPlaceButton(title: viewStore.place)
                .foregroundColor(.black)
            }
            .padding(.top, 5)
            .padding(.bottom, 8)
          }
          
          ZStack(alignment: .topLeading) {
            TextEditor(text: viewStore.binding(get: \.text, send: DiaryCore.Action.textDidEditting))
              .foregroundColor(.black)
              .colorMultiply(Color(R.color.gray02))
              .frame(height: keyboardResponder.currentHeight == 0 ? 332 : 320)
              .lineSpacing(5)
              .cornerRadius(10)
            
            if viewStore.state.text.isEmpty {
              Text(R.string.localizable.diary_edit_text)
                .foregroundColor(Color(R.color.gray06))
                .padding(.top, 10)
                .padding(.leading, 10)
            }
          }
          
          HStack {
            ImagePickerView(selectedUIImage: $image, representImage: Image(R.image.img_addImage))
              .frame(width: 64, height: 64)
            
            Spacer()
          }
          .padding(.top, 30)
          .padding(.leading, 36)
          
          Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 10)
        .padding(.horizontal, 16)
      }
    }
    .padding(.bottom, keyboardResponder.currentHeight == 0 ? 0 : keyboardResponder.currentHeight + 524 - UIScreen.main.bounds.height)
    .onAppear {
      UITextView.appearance().textContainerInset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    }
    .padding(.top, 5)
  }
}

struct DiaryView_Previews: PreviewProvider {
  static var previews: some View {
    DiaryView(store: Store(initialState: DiaryCore.State(), reducer: DiaryCore()))
  }
}

