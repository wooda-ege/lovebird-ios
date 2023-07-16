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
          title: "",
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
              Text(viewStore.schedule.title)
                .font(.pretendard(size: 16))
                .foregroundColor(.black)

              Spacer()
            }

            ScheduleAddFocusedView() {
              Circle()
              // FIXME: 득연
                .fill(Color.red)
                .frame(width: 12, height: 12)
                .padding(6)

              Text(viewStore.schedule.color.description)
                .font(.pretendard(size: 16, weight: .bold))
                .foregroundColor(.black)

              Spacer()
            }

            ScheduleAddFocusedView {
              VStack {
                Image(R.image.ic_calendar)
                  .renderingMode(.template)
                  .foregroundColor(Color(R.color.primary))

                Spacer()
              }

              let schedule = viewStore.schedule
              if schedule.startDate == schedule.endDate {
                Text(String.toScheduleDateWith(
                  date: schedule.startDate,
                  startTime: schedule.startTime,
                  endTime: schedule.endTime
                ))
                .font(.pretendard(size: 16))
                .foregroundColor(.black)
                Spacer()
              } else {
                HStack(spacing: 8) {
                  VStack(spacing: 4) {
                    Text("시작 FIXME")
                      .font(.pretendard(size: 12, weight: .bold))
                      .foregroundColor(Color(R.color.gray06))
                      .frame(maxWidth: .infinity, alignment: .leading)

                    Text(String.toScheduleDateWith(
                      date: schedule.startDate,
                      startTime: nil,
                      endTime: nil
                    ))
                    .font(.pretendard(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(schedule.startTime?.toScheduleTime() ?? "")
                      .font(.pretendard(size: 16))
                      .frame(maxWidth: .infinity, alignment: .leading)
                  }
                  .frame(maxWidth: .infinity)

                  VStack(spacing: 4) {
                    Text("종료 FIXME")
                      .font(.pretendard(size: 12, weight: .bold))
                      .foregroundColor(Color(R.color.gray06))
                      .frame(maxWidth: .infinity, alignment: .leading)

                    Text(String.toScheduleDateWith(
                      date: schedule.endDate,
                      startTime: nil,
                      endTime: nil
                    ))
                    .font(.pretendard(size: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(schedule.endTime?.toScheduleTime() ?? "")
                      .font(.pretendard(size: 16))
                      .frame(maxWidth: .infinity, alignment: .leading)
                  }
                  .frame(maxWidth: .infinity)
                }
              }
            }

            if viewStore.schedule.memo.isNotEmpty {
              ScheduleAddFocusedView {
                HStack(alignment: .top) {
                  VStack(spacing: 12) {
                    Text("메모")
                      .font(.pretendard(size: 16))
                      .foregroundColor(Color(R.color.gray06))
                      .frame(maxWidth: .infinity, alignment: .leading)

                    Text(viewStore.schedule.memo)
                      .font(.pretendard(size: 16))
                      .foregroundColor(.black)
                      .frame(maxWidth: .infinity, minHeight: 200, alignment: .topLeading)
                  }
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

