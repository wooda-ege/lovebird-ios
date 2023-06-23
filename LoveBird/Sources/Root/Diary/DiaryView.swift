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
  @State var image: Image? = nil
  @State var place: String = "장소 선택"
  
  init(store: StoreOf<DiaryCore>) {
    self.store = store
  }
  
  
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        VStack {
          TextField("제목", text: viewStore.binding(get: \.title, send: DiaryCore.DiaryCoreAction.titleLabelTapped)
          )
          .padding([.top, .bottom], 10)
          .padding(.leading, 15)
          .frame(height: 44)
          .background(Color(uiColor: .secondarySystemBackground))
          .textFieldStyle(.plain)
          .cornerRadius(10)
          .navigationBarTitleDisplayMode(.inline)
          .navigationTitle("일기 쓰기")
          .navigationBarItems(trailing:
                                Button("완료") {
            image = nil
            place = "장소 선택"
            
            viewStore.send(.completeButtonTapped)
          })
          
          NavigationLink(destination: SearchPlaceView(store: Store(initialState: SearchPlaceCore.State(), reducer: SearchPlaceCore()), placeSelection: $place)
            .padding(.top, 20)
            .padding(.bottom, 10)
            .padding([.leading, .trailing], 15)
          ) {
            ZStack(alignment: .center) {
              place == "장소 선택" ? CustomButton(title: place)
                .foregroundColor(.gray)
                .padding(.top, 5)
                .padding(.bottom, 8) : CustomButton(title: place)
                .foregroundColor(.black)
                .padding(.top, 5)
                .padding(.bottom, 8)
            }
          }
          
          ZStack(alignment: .topLeading) {
            TextEditor(text: viewStore.binding(get: \.text, send: DiaryCore.DiaryCoreAction.textDidEditting))
              .foregroundColor(.black)
              .colorMultiply(Color(uiColor: .secondarySystemBackground))
              .foregroundColor(.black)
              .frame(height: 342)
              .lineSpacing(5)
              .cornerRadius(10)
            
            if viewStore.state.text.isEmpty {
              Text(R.string.localizable.diary_edit_text)
                .foregroundColor(.gray)
                .padding(.top, 10)
                .padding(.leading, 10)
            }
          }
          ImagePickerView(image: $image)
            .padding(.top, 10)
          
          Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding(.top, 10)
        .padding([.trailing, .leading], 16)
      }
      .onAppear {
        UITextView.appearance().textContainerInset =
        UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
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

