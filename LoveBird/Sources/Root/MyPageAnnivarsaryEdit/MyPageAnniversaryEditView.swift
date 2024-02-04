//
//  MyPageAnniversaryEditView.swift
//  LoveBird
//
//  Created by 이 on 2023/08/13.
//

import ComposableArchitecture
import SwiftUI

struct MyPageAnniversaryEditView: View {
  @FocusState var isAnniversaryFocused: Bool
  @FocusState var isBirthdateFocused: Bool
  
  let store: StoreOf<MyPageAnniversaryEditCore>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        TopAlignedVStack(spacing: 20) {
          toolbar
          firstDateView
          birthdayView
        }
        
        firstDatePickerView
        birthdayPickerView
      }
      .navigationBarBackButtonHidden(true)
    }
  }
}

private extension MyPageAnniversaryEditView {
  var toolbar: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonToolBar(title: "기념일 정보") {
        viewStore.send(.backTapped)
      } content: {
        Button {
          viewStore.send(.editTapped)
        } label: {
          Text("수정")
            .foregroundColor(Color(.primary))
            .font(.pretendard(size: 16, weight: .bold))
        }
      }
    }
  }

  var firstDateView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        LeftAlignedHStack {
          Text("기념일")
            .foregroundColor(.black)
            .font(.pretendard(size: 14))
        }

        TouchableView {
          LeftAlignedHStack {
            Text(viewStore.firstDate.toYMDFormat())
              .font(.pretendard(size: 18))
              .foregroundColor(
                viewStore.currentState == .firstDate
                  ? Color(asset: LoveBirdAsset.gray10)
                  : Color(asset: LoveBirdAsset.gray05)
              )
          }
        }
        .padding([.vertical, .leading], 16)
        .roundedBackground(
          cornerRadius: 12,
          color: viewStore.currentState == .firstDate
            ? Color(asset: LoveBirdAsset.gray10)
            : Color(asset: LoveBirdAsset.gray05)
        )
        .onTapGesture {
          viewStore.send(.firstDateTapped)

        }
      }
      .padding(.horizontal, 16)
    }
  }

  var birthdayView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(spacing: 10) {
        LeftAlignedHStack {
          Text("생일")
            .foregroundColor(.black)
            .font(.pretendard(size: 14))
        }

        TouchableView {
          LeftAlignedHStack {
            Text(viewStore.birthday.toYMDFormat())
              .font(.pretendard(size: 18))
              .foregroundColor(
                viewStore.currentState == .birthday
                  ? Color(asset: LoveBirdAsset.gray10)
                  : Color(asset: LoveBirdAsset.gray05))
          }
        }
        .padding([.vertical, .leading], 16)
        .roundedBackground(
          cornerRadius: 12,
          color: viewStore.currentState == .birthday
            ? Color(asset: LoveBirdAsset.gray10)
            : Color(asset: LoveBirdAsset.gray05)
        )
        .onTapGesture {
          viewStore.send(.birthdayTapped)
        }
      }
      .padding(.horizontal, 16)
    }
  }

  var firstDatePickerView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonBottomSheetView(isOpen: viewStore.binding(
        get: \.shouldShowFirstDatePickerView,
        send: MyPageAnniversaryEditAction.firstDatePickerViewVisible
      )) {
        VStack {
          DatePickerView(date: viewStore.binding(
            get: \.firstDate, send: MyPageAnniversaryEditAction.firstDateUpdated
          ))

          HStack(spacing: 8) {
            CommonHorizontalButton(
              title: LoveBirdStrings.onboardingDateInitial,
              backgroundColor: Color(asset: LoveBirdAsset.gray05)
            ) {
              viewStore.send(.firstDateInitialized)
            }

            CommonHorizontalButton(
              title: LoveBirdStrings.commonConfirm,
              backgroundColor: .black
            ) {
              viewStore.send(.firstDatePickerViewVisible(false))
            }
          }
          .padding(.horizontal, 16)
        }
      }
    }
  }

  var birthdayPickerView: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      CommonBottomSheetView(isOpen: viewStore.binding(
        get: \.shouldShowBirthdayPickerView,
        send: MyPageAnniversaryEditAction.birthdayPickerViewVisible
      )) {
        VStack {
          DatePickerView(date: viewStore.binding(
            get: \.birthday, send: MyPageAnniversaryEditAction.birthdayUpdated
          ))

          HStack(spacing: 8) {
            CommonHorizontalButton(
              title: LoveBirdStrings.onboardingDateInitial,
              backgroundColor: Color(asset: LoveBirdAsset.gray05)
            ) {
              viewStore.send(.birthdayInitialized)
            }

            CommonHorizontalButton(
              title: LoveBirdStrings.commonConfirm,
              backgroundColor: .black
            ) {
              viewStore.send(.birthdayPickerViewVisible(false))
            }
          }
          .padding(.horizontal, 16)
        }
      }
    }
  }
}

#Preview {
  MyPageAnniversaryEditView(
    store: .init(
      initialState: MyPageAnniversaryEditState(profile: .dummy),
      reducer: { MyPageAnniversaryEditCore() }
    )
  )
}
