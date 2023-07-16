//
//  ScheduleDetailView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/04.
//

import ComposableArchitecture
import SwiftUI

struct ScheduleDetailView: View {

  let store: StoreOf<ScheduleDetailCore>

  var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        CommonToolBar(
          title: viewStore.detail.title,
          backButtonTapped: { viewStore.send(.backButtonTapped) }
        ) {
          HStack(spacing: 16) {
            NavigationLinkStore(
              self.store.scope(state: \.$scheduleAdd, action: ScheduleDetailAction.scheduleAdd)
            ) {
              viewStore.send(.editTapped)
            } destination: { store in
              ScheduleAddView(store: store)
            } label: {
              Image(R.image.ic_edit)
            }

            Button { viewStore.send(.deleteTapped) } label: {
              Image(R.image.ic_delete)
            }
          }
        }

        ScrollView {
          VStack {
            ScheduleAddFocusedView() {
              Circle()
                .fill(viewStore.detail.color.color)
                .frame(width: 12, height: 12)
                .padding(6)

              Text(viewStore.detail.color.description)
                .font(.pretendard(size: 16, weight: .bold))
                .foregroundColor(.black)

              Spacer()
            }

            ScheduleAddFocusedView {
              Image(R.image.ic_calendar)
                .renderingMode(.template)
                .foregroundColor(Color(R.color.primary))

              Text(String.toScheduleDateWith(startDate: viewStore.detail.startDate, endDate: viewStore.detail.endDate))

              Spacer()
            }

            ScheduleAddFocusedView {
              HStack(alignment: .top) {
                VStack(spacing: 12) {
                  Text("메모")
                    .font(.pretendard(size: 16))
                    .foregroundColor(Color(R.color.gray06))
                    .frame(maxWidth: .infinity, alignment: .leading)

                  Text(viewStore.detail.memo)
                    .font(.pretendard(size: 16))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                }
              }
            }
          }
          .padding(.horizontal, 16)
        }
      }
      .navigationBarBackButtonHidden(true)

    }
  }
}

//struct ScheduleDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleDetailView()
//    }
//}

