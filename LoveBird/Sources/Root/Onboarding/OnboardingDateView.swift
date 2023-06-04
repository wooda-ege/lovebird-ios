//
//  OnboardingDateView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI
import ComposableArchitecture

struct OnboardingDateView: View {
    
    let store: StoreOf<OnboardingCore>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                VStack {
                    Spacer().frame(height: 24)
                    Text(R.string.localizable.onboarding_date_title)
                        .font(.pretendard(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    Text(R.string.localizable.onboarding_date_description)
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
                    .frame(width: UIScreen.width - 32, height: 56)
                    .contentShape(Rectangle())
                    .roundedBackground(cornerRadius: 12, color: Color(R.color.primary))
                    .onTapGesture {
                        viewStore.send(.showBottomSheet)
                    }
                    
                    Spacer()
                        
                    Button(action: {
                        viewStore.send(.doneButtonTapped)
                    }) {
                        TouchableStack {
                            Text(R.string.localizable.common_next)
                                .font(.pretendard(size: 16, weight: .semiBold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(height: 56)
                    .background(.black)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white)
                
                if viewStore.showBottomSheet {
                    BottomSheetView(isOpen: viewStore.binding(
                        get: \.showBottomSheet,
                        send: .hideBottomSheet
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
                                    Text(R.string.localizable.onboarding_date_initial)
                                        .font(.pretendard(size: 16, weight: .semiBold))
                                        .frame(maxWidth: .infinity, maxHeight: 56)
                                        .background(Color(R.color.gray214))
                                        .cornerRadius(12)
                                }

                                Button(action: {
                                    viewStore.send(.hideBottomSheet)
                                }) {
                                    Text(R.string.localizable.common_next)
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
