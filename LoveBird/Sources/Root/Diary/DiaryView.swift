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
  
  //  @State var title: String = ""
  //  @State var place: String = "장소 선택"
  //  @State var isPresented = false
  //  @State private var text: String = ""
  
  init(store: StoreOf<DiaryCore>) {
    self.store = store
    UITextView.appearance().textContainerInset =
    UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
  }
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        VStack {
          TextField("제목", text: viewStore.binding(get: \.title, send: DiaryCore.DiaryCoreAction.titleLabelTapped)
          )
          .padding(.top, 10)
          .padding(.bottom, 10)
          .padding(.leading, 15)
          .background(Color(uiColor: .secondarySystemBackground))
          .textFieldStyle(.plain)
          .cornerRadius(10)
          .frame(height: 44)
          .navigationBarTitleDisplayMode(.inline)
          .navigationTitle("일기 쓰기")
          .navigationBarItems(trailing:
                                Button("완료") {
                                  print("완료 버튼 눌렀습니동동동동")
              viewStore.send(.completeButtonTapped(diary))
                                })
          .navigationBarBackButtonHidden(true)
          
            NavigationLink(destination: SearchPlaceView(store: Store(initialState: SearchPlaceCore.State(), reducer: SearchPlaceCore()))
            .padding(.top, 20)
            .padding(.bottom, 10)
            .padding(.leading, 15)
            .padding(.trailing, 15)
          ) {
            ZStack(alignment: .center) {
              let placeholder: String = "장소 선택"
              
              if viewStore.place == placeholder {
                CustomButton(title: viewStore.state.place)
                  .foregroundColor(.gray)
                  .padding(.top, 5)
                  .padding(.bottom, 8)
              } else {
                CustomButton(title: viewStore.state.place)
                  .foregroundColor(.black)
                  .padding(.top, 5)
                  .padding(.bottom, 8)
              }
            }
          }
          
          ZStack(alignment: .topLeading) {
            let placeholder: String = "내용을 입력해 주세요."
            
            TextEditor(text: viewStore.binding(get: \.text, send: DiaryCore.DiaryCoreAction.textDidEditting))
              .foregroundColor(.black)
              .frame(height: 342)
              .lineSpacing(5)
              .cornerRadius(10)
              .colorMultiply(Color(uiColor: .secondarySystemBackground))
            //          .scrollContentBackground(.hidden)
//              .onTapGesture {
//                if viewStore.state.text == placeholder {
//                  viewStore.send(.changeTextEmpty)
//                }
//              }
              .foregroundColor(.black)
            
            if viewStore.state.text.isEmpty {
              Text(placeholder)
                .foregroundColor(.gray)
                .padding(.top, 10)
                .padding(.leading, 10)
            }
          }
          
          ImagePickerView()
            .padding(.top, 10)
          
          Spacer()
        }
        .padding(.top, 10)
        .padding(.trailing, 16)
        .padding(.leading, 16)
      }
    }
    .padding(.top, 5)
  }
}

//struct WritingDiaryView_Previews: PreviewProvider {
//  static var previews: some View {
//    WritingDiaryView()
//  }
//}

