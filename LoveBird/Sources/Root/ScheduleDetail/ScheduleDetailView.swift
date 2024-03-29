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
        CommonToolBar(backAction: { viewStore.send(.backTapped) }) {
          HStack(spacing: 16) {
            Button { viewStore.send(.editTapped) } label: {
              Image(asset: LoveBirdAsset.icEdit)
            }

            Button { viewStore.send(.deleteTapped) } label: {
              Image(asset: LoveBirdAsset.icDelete)
            }
          }
        }

        ScrollView {
          VStack {
            CommonFocusedView() {
              Text(viewStore.schedule.title)
                .font(.pretendard(size: 16))
                .lineLimit(0)
                .foregroundColor(.black)

              Spacer()
            }

            CommonFocusedView() {
              Circle()
                .fill(viewStore.schedule.color.color)
                .frame(width: 12, height: 12)
                .padding(6)

              Text(viewStore.schedule.color.description)
                .font(.pretendard(size: 16))
                .foregroundColor(.black)

              Spacer()
            }

            CommonFocusedView {
              let schedule = viewStore.schedule
              if schedule.startDate == schedule.endDate {
                Image(asset: LoveBirdAsset.icCalendar)
                  .changeColor(to: Color(asset: LoveBirdAsset.primary))
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
                  Image(asset: LoveBirdAsset.icCalendar)
                    .changeColor(to: Color(asset: LoveBirdAsset.primary))
                    .changeSize(to: .init(width: 24, height: 24))

                  Spacer()
                }

                HStack(spacing: 8) {
                  VStack(spacing: 4) {
                    Text("시작")
                      .font(.pretendard(size: 12, weight: .bold))
                      .foregroundColor(Color(asset: LoveBirdAsset.gray06))
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
                      .foregroundColor(Color(asset: LoveBirdAsset.gray06))
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
              CommonFocusedView {
                Image(asset: LoveBirdAsset.icNotificationPrimary)
                  .changeColor(to: Color(asset: LoveBirdAsset.primary))
                  .changeSize(to: .init(width: 24, height: 24))

                Text(alarm.description)
                .font(.pretendard(size: 16))
                .foregroundColor(.black)

                Spacer()
              }
            }

            if viewStore.schedule.memo != nil {
              CommonFocusedView {
                HStack(alignment: .top) {
                  VStack(spacing: 12) {
                    Text("메모")
                      .font(.pretendard(size: 16))
                      .foregroundColor(Color(asset: LoveBirdAsset.gray06))
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

#Preview {
  ScheduleDetailView(
    store: .init(
      initialState: ScheduleDetailState(schedule: .dummy),
      reducer: { ScheduleDetailCore() }
    )
  )
}
