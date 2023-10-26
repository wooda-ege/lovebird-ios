//
//  ScheduleAddTitleView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddTitleView: View {
  let store: StoreOf<ScheduleAddCore>
  @FocusState var isKeyboardFocused: Bool

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonFocusedView(isFocused: viewStore.focusedType == .title) {
        let textBinding = viewStore.binding(get: \.title, send: ScheduleAddAction.titleEdited)
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
      .onChange(of: viewStore.focusedType) { focusedType in
        self.hideKeyboard()
        DispatchQueue.main.async {
          self.isKeyboardFocused = focusedType == .title
        }
      }
      .onTapGesture {
        viewStore.send(.contentTapped(.title))
      }
    }
  }
}

#Preview {
  ScheduleAddTitleView(
    store: .init(
      initialState: ScheduleAddState(schedule: .dummy),
      reducer: { ScheduleAddCore() }
    )
  )
}
