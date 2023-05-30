//
//  OnboardingBirthView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingBirthView: View {
    
    let store: StoreOf<OnboardingCore>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    Spacer().frame(height: 24)
                    Text("연인과 사랑을 시작한 날짜를 알려주세요")
                        .font(.pretendard(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text("러브버드가 기념일을 계산해서 알려드릴게요")
                        .font(.pretendard(size: 16, weight: .regular))
                        .foregroundColor(Color(R.color.gray156))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 12)
                        .padding(.leading, 16)
                    Spacer()
                        .frame(height: 48)
                    HStack(alignment: .center, spacing: 8) {
                        Text(String(viewStore.year))
                            .font(.pretendard(size: 18))
                        Text("/")
                            .font(.pretendard(size: 18))
                            .foregroundColor(Color(R.color.gray214))
                        Text(String(viewStore.month))
                            .font(.pretendard(size: 18))
                        Text("/")
                            .font(.pretendard(size: 18))
                            .foregroundColor(Color(R.color.gray214))
                        Text(String(viewStore.day))
                            .font(.pretendard(size: 18))
                    }
                    .onTapGesture {
                        viewStore.send(.showBottomSheet)
                    }
                    .frame(width: UIScreen.width - 32, height: 56)
                    .roundedBackground(cornerRadius: 12, color: Color(R.color.primary))
                    Spacer()
                    Button(action: {
                        viewStore.send(.doneButtonTapped)
                    }) {
                        ZStack {
                            Text("다음")
                                .font(.pretendard(size: 16, weight: .semiBold))
                            Rectangle()
                                .fill(Color.clear)
                        }
                    }
                    .frame(width: UIScreen.width - 32, height: 56)
                    .background(.black)
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                
                if viewStore.showBottomSheet {
                    BottomSheetView(isOpen: viewStore.binding(
                        get: \.showBottomSheet,
                        send: .none
                    )) {
                        VStack {
                            CustomPickerView(
                                year: viewStore.binding(get: \.year, send: OnboardingCore.Action.yearSelected),
                                month: viewStore.binding(get: \.month, send: OnboardingCore.Action.monthSelected),
                                day: viewStore.binding(get: \.day, send: OnboardingCore.Action.daySelected))
                            HStack(spacing: 8) {
                                Button(action: {
                                    viewStore.send(.dateInitialied)
                                }) {
                                    Text("초기화")
                                        .font(.pretendard(size: 16, weight: .semiBold))
                                        .frame(maxWidth: .infinity, maxHeight: 56)
                                        .background(Color(R.color.gray214))
                                        .cornerRadius(12)
                                }

                                Button(action: {
                                    viewStore.send(.hideBottomSheet)
                                }) {
                                    Text("확인")
                                        .font(.pretendard(size: 16, weight: .semiBold))
                                        .frame(maxWidth: .infinity, maxHeight: 56)
                                        .background(.black)
                                        .cornerRadius(12)
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
                        }
                    }
                }
            }
        }
    }
}

//struct OnboardingBirthView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingBirthView()
//    }
//}
