//
//  ScheduleAddMemoView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/30.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddMemoView: View {

  let store: StoreOf<ScheduleAddCore>
  @FocusState var isKeyboardFocused: Bool

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonFocusedView(isFocused: viewStore.focusedType == .memo) {
        VStack(spacing: 12) {
          Text("메모")
            .font(.pretendard(size: 16))
            .foregroundColor(Color(asset: LoveBirdAsset.gray06))
            .frame(maxWidth: .infinity, alignment: .leading)

          TextEditor(text: viewStore.binding(get: \.memo, send: ScheduleAddAction.memoEdited))
            .colorMultiply(Color(asset: viewStore.focusedType == .memo ? LoveBirdAsset.gray01 : LoveBirdAsset.gray02))
            .focused($isKeyboardFocused)
            .frame(height: 200) // TODO: 득연 - 논의 해봐야 함
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 32)
        }
      }
      .onChange(of: viewStore.focusedType) {
        self.hideKeyboard()
        self.isKeyboardFocused = $0 == .memo
      }
      .onTapGesture {
        viewStore.send(.contentTapped(.memo))
      }
    }
  }
}

#Preview {
  ScheduleAddMemoView(
    store: .init(
      initialState: ScheduleAddState(schedule: .dummy),
      reducer: { ScheduleAddCore() }
    )
  )
}
