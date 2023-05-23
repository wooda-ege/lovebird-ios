//
//  OnboardingBirthView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

struct OnboardingBirthView: View {
    
    @State private var showBottomSheet = false
    @State private var selectedOption = 1
    let options = ["Option 1", "Option 2", "Option 3"]
    @State private var year: String = "2023"
    @State private var month: String = "5"
    @State private var day: String = "14"
    @State private var selectedYear = 2023
        @State private var selectedMonth = 1
        @State private var selectedDay = 1
    @State private var selectedDate = DateComponents(year: 2023, month: 1, day: 1)

    
    var body: some View {
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
                    Text($year.wrappedValue)
                        .font(.pretendard(size: 18, weight: .regular))
                    Text("/")
                        .font(.pretendard(size: 18, weight: .regular))
                        .foregroundColor(Color(R.color.gray214))
                    Text($month.wrappedValue)
                        .font(.pretendard(size: 18, weight: .regular))
                    Text("/")
                        .font(.pretendard(size: 18, weight: .regular))
                        .foregroundColor(Color(R.color.gray214))
                    Text($day.wrappedValue)
                        .font(.pretendard(size: 18, weight: .regular))
                }
                .onTapGesture {
                    self.showBottomSheet = true
                }
                .frame(width: UIScreen.width - 32, height: 56)
                .roundedBackground(cornerRadius: 12, color: Color(R.color.primary))
                Spacer()
                Button(action: {
                    
                }) {
                    Text("다음")
                        .font(.pretendard(size: 16, weight: .semiBold))
                }
                .frame(width: UIScreen.width - 32, height: 56)
                .background(.black)
                .cornerRadius(12)
                .foregroundColor(.white)
                .padding(.bottom, 20 + UIApplication.edgeInsets.bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
            
            if showBottomSheet {

                BottomSheetView(isOpen: $showBottomSheet) {
                    VStack {
                        CustomPickerView(selectedDate: $selectedDate)
                        HStack(spacing: 8) {
                            Button(action: {
                                showBottomSheet = false
                            }) {
                                Text("초기화")
                                    .font(.pretendard(size: 16, weight: .semiBold))
                                    .frame(maxWidth: .infinity, maxHeight: 56)
                                    .background(Color(R.color.gray214))
                                    .cornerRadius(12)
                            }

                            Button(action: {
                                showBottomSheet = false
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

struct OnboardingBirthView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingBirthView()
    }
}
