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
    WithViewStore(self.store, observe: { $0 }) { viewStore in
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
            ScheduleFocusedView() {
              Text(viewStore.schedule.title)
                .font(.pretendard(size: 16))
                .lineLimit(0)
                .foregroundColor(.black)

              Spacer()
            }

            ScheduleFocusedView() {
              Circle()
                .fill(viewStore.schedule.color.color)
                .frame(width: 12, height: 12)
                .padding(6)

              Text(viewStore.schedule.color.description)
                .font(.pretendard(size: 16))
                .foregroundColor(.black)

              Spacer()
            }

            ScheduleFocusedView {
              let schedule = viewStore.schedule
              if schedule.startDate == schedule.endDate {
                Image(R.image.ic_calendar)
                  .changeColor(to: Color(R.color.primary))
                  .changeSize(to: .init(width: 24, height: 24))

                Text(String.toScheduleDateWith(
                  date: schedule.startDate,
                  startTime: schedule.startTime,
                  endTime: schedule.endTime
                ))
                .font(.pretendard(size: 16))
                .lineLimit(0)
                .foregroundColor(.black)

                Spacer()
              } else {
                VStack {
                  Image(R.image.ic_calendar)
                    .changeColor(to: Color(R.color.primary))
                    .changeSize(to: .init(width: 24, height: 24))

                  Spacer()
                }

                HStack(spacing: 8) {
                  VStack(spacing: 4) {
                    Text("시작")
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
                    Text("종료")
                      .font(.pretendard(size: 12, weight: .bold))
                      .foregroundColor(Color(R.color.gray06))
                      .frame(maxWidth: .infinity, alignment: .leading)

                    Text(String.toScheduleDateWith(
                      date: schedule.endDate ?? "",
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

            if let alarm = viewStore.schedule.alarm {
              ScheduleFocusedView {
                Image(R.image.ic_notification_primary)
                  .changeColor(to: Color(R.color.primary))
                  .changeSize(to: .init(width: 24, height: 24))

                Text(alarm.description)
                .font(.pretendard(size: 16))
                .foregroundColor(.black)

                Spacer()
              }
            }

            if viewStore.schedule.memo != nil {
              ScheduleFocusedView {
                HStack(alignment: .top) {
                  VStack(spacing: 12) {
                    Text("메모")
                      .font(.pretendard(size: 16))
                      .foregroundColor(Color(R.color.gray06))
                      .frame(maxWidth: .infinity, alignment: .leading)

                    Text(viewStore.schedule.memo ?? "")
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

