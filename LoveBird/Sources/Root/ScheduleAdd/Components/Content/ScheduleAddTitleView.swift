//
//  ScheduleAddTitleView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddTitleView: View {

  @FocusState var isKeyboardFocused: Bool
  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>

  var body: some View {
    CommonFocusedView(isFocused: self.viewStore.focusedType == .title) {
      let textBinding = self.viewStore.binding(get: \.title, send: ScheduleAddAction.titleEdited)
      TextField("일정 제목을 입력해 주세요", text: textBinding)
        .font(.pretendard(size: 18))
        .background(.clear)
        .padding(.trailing, 32)
        .focused($isKeyboardFocused)
        .frame(maxWidth: .infinity, alignment: .leading)
        .showClearButton(textBinding, trailingPadding: 2)
    }
    .onAppear {
      self.isKeyboardFocused = true
    }
    .onChange(of: self.viewStore.focusedType) { focusedType in
      self.hideKeyboard()
      DispatchQueue.main.async {
        self.isKeyboardFocused = focusedType == .title
      }
    }
    .onTapGesture {
      self.viewStore.send(.contentTapped(.title))
    }
  }
}

//struct AddScheduleTitleView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddScheduleTitleView()
//  }
//}
