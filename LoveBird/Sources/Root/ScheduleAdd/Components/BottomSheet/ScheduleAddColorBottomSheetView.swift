//
//  ScheduleAddColorBottomSheetView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/01.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleAddColorBottomSheetView: View {

  let viewStore: ViewStore<ScheduleAddState, ScheduleAddAction>

  var body: some View {
    CommonBottomSheetView(isOpen: self.viewStore.binding(get: \.showColorBottomSheet, send: .hideColorBottomSheet)) {
      VStack {
        ForEach(ScheduleColor.allCases.filter { $0 != .none }, id: \.color) { color in
          VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 18) {
              Circle()
                .fill(color.color)
                .frame(width: 12, height: 12)

              Text(color.description)
                .font(.pretendard(size: 16))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

              if self.viewStore.color == color {
                Image(asset: LoveBirdAsset.icCheckCircle)
                  .resizable()
                  .frame(width: 24, height: 24)
              }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 16)

            Rectangle()
              .fill(Color(asset: LoveBirdAsset.gray03))
              .frame(height: 1)
          }
          .frame(maxWidth: .infinity)
          .background(.white)
          .onTapGesture {
            self.viewStore.send(.colorSelected(color))
          }
        }
      }
      .padding(.horizontal ,16)
    }
  }
}

//struct AddScheduleColorBottomSheetView_Previews: PreviewProvider {
//  static var previews: some View {
//    AddScheduleColorBottomSheetView()
//  }
//}
