//
//  ScheduleAddMemoView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddMemoView: View {

  @FocusState var isKeyboardFocused: Bool
  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>
  let isFocused: Bool

  init(viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>) {
    self.viewStore = viewStore
    self.isFocused = viewStore.focusedType == .memo
  }

  var body: some View {
    ScheduleAddFocusedView(isFocused: self.isFocused) {
      VStack(spacing: 12) {
        Text("메모")
          .font(.pretendard(size: 16))
          .foregroundColor(Color(R.color.gray06))
          .frame(maxWidth: .infinity, alignment: .leading)

        TextEditor(text: self.viewStore.binding(get: \.memo, send: ScheduleAddAction.memoEdited))
          .colorMultiply(Color(self.isFocused ? R.color.gray01 : R.color.gray02))
          .focused($isKeyboardFocused)
          .frame(height: 200) // TODO: 득연 - 논의 해봐야 함
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.bottom, 32)
      }
    }
    .onChange(of: self.viewStore.focusedType) {
      self.hideKeyboard()
      self.isKeyboardFocused = $0 == .memo
    }
    .onTapGesture {
      self.viewStore.send(.contentTapped(.memo))
    }
  }
}

//struct AddScheduleSettingView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddScheduleMemoView()
//  }
//}
