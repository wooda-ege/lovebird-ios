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
        UITextView.appearance().textContainerInset =
        UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                VStack {
                    let placeholder: String = "장소 선택"
                    
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
                        viewStore.send(.completeButtonTapped)
                        image = nil
                        place = placeholder
                    })
                    .navigationBarBackButtonHidden(true)
                    
                    NavigationLink(destination: IfLetStore(self.store.scope(state: \.searchPlace, action: DiaryCore.Action.searchPlace)) {
                        SearchPlaceView(store: $0)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .padding(.leading, 15)
                            .padding(.trailing, 15)
                    }) {
                        ZStack(alignment: .center) {
                            if place == placeholder {
                                CustomButton(title: place)
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                                    .padding(.bottom, 8)
                            } else {
                                CustomButton(title: place)
                                    .foregroundColor(.black)
                                    .padding(.top, 5)
                                    .padding(.bottom, 8)
                            }
                        }
                    }
                    .navigationTitle("New Game")
//                    .navigationBarItems(trailing: Button("Logout") { viewStore.send(.logoutButtonTapped) })
                    
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
                    ImagePickerView(image: $image)
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

