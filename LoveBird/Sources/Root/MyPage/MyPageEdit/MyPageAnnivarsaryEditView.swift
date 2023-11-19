//
//  MyPageAnnivarsaryEditView.swift
//  LoveBird
//
//  Created by 이 on 2023/08/13.
//

import ComposableArchitecture
import SwiftUI

struct MyPageAnnivarsaryEditView: View {
  @FocusState var isAnnivarsaryFocused: Bool
  @FocusState var isBirthdateFocused: Bool
  
  let store: StoreOf<MyPageProfileEditCore>
  
  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      ZStack {
        VStack(spacing: 20) {
          CommonToolBar(title: "기념일 정보") {
            viewStore.send(.backButtonTapped)
          } content: {
            Button {
              viewStore.send(.annivarsaryEditTapped)
            } label: {
              Text("수정")
                .foregroundColor(Color(.gray12))
                .font(.pretendard(size: 16, weight: .bold))
            }
          }
          
          VStack(spacing: 10) {
            HStack {
              Text("기념일")
                .foregroundColor(.black)
                .font(.pretendard(size: 14))
              
              Spacer()
            }
            
            HStack {
              Text(viewStore.annivarsary.toYMDFormat())
              Spacer()
            }
            .padding([.vertical, .leading], 16)
            .roundedBackground(
              cornerRadius: 12,
              color: Color(asset: LoveBirdAsset.gray06)
            )
            .onTapGesture {
              viewStore.send(.changeCurrentState(.annivarsary))
              viewStore.send(.showBottomSheet)
            }
            
          }
          .padding(.horizontal, 16)
          
          VStack(spacing: 10) {
            HStack {
              Text("생일")
                .foregroundColor(.black)
                .font(.pretendard(size: 14))
              
              Spacer()
            }
            
            HStack {
              Text(viewStore.birthdate.toYMDFormat())
              Spacer()
            }
            .padding([.vertical, .leading], 16)
            .roundedBackground(
              cornerRadius: 12,
              color: Color(asset: LoveBirdAsset.gray06)
            )
            .onTapGesture {
              viewStore.send(.changeCurrentState(.birthdate))
              viewStore.send(.showBottomSheet)
            }
          }
          .padding(.horizontal, 16)
          
          Spacer()
        }
        
        if viewStore.showBottomSheet {
          CommonBottomSheetView(isOpen: viewStore.binding(
            get: \.showBottomSheet,
            send: .hideBottomSheet
          )) {
            VStack {
              DatePickerView(
                date: viewStore.currentState == .annivarsary ? viewStore.binding(get: \.annivarsary, send: MyPageProfileEditAction.annivarsaryUpdated) : viewStore.binding(get: \.birthdate, send: MyPageProfileEditAction.birthdateUpdated)
              )
        
              HStack(spacing: 8) {
                CommonHorizontalButton(
                  title: LoveBirdStrings.onboardingDateInitial,
                  backgroundColor: Color(asset: LoveBirdAsset.gray05)
                ) {
                  if viewStore.currentState == .annivarsary {
                    viewStore.send(.anniversaryInitialized)
                  } else {
                    viewStore.send(.birthdateInitialized)
                  }
                }
        
                CommonHorizontalButton(
                  title: LoveBirdStrings.commonConfirm,
                  backgroundColor: .black
                ) {
                  viewStore.send(.hideBottomSheet)
                }
              }
              .padding(.horizontal, 16)
            }
          }
        }
      }
      .navigationBarBackButtonHidden(true)
      .onAppear {
        viewStore.send(.viewAppear)
      }
    }
  }
}

#Preview {
  MyPageAnnivarsaryEditView(
    store: .init(
      initialState: MyPageProfileEditState(),
      reducer: { MyPageProfileEditCore() }
    )
  )
}

//if viewStore.showBottomSheet {
//  CommonBottomSheetView(isOpen: viewStore.binding(
//    get: \.showBottomSheet,
//    send: .hideBottomSheet
//  )) {
//    VStack {
//      DatePickerView(
//        date: viewStore.binding(get: \.annivarsary, send: OnboardingAction.annivarsaryUpdated)
//      )
//
//      HStack(spacing: 8) {
//        CommonHorizontalButton(
//          title: LoveBirdStrings.onboardingDateInitial,
//          backgroundColor: Color(asset: LoveBirdAsset.gray05)
//        ) {
//            viewStore.send(.anniversaryInitialized)
//        }
//
//        CommonHorizontalButton(
//          title: LoveBirdStrings.commonConfirm,
//          backgroundColor: .black
//        ) {
//          viewStore.send(.hideBottomSheet)
//        }
//      }
//      .padding(.horizontal, 16)
//    }
//  }
//}
