//
//  OnboardingNicknameView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/20.
//

import SwiftUI

struct OnboardingNicknameView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 24)
            Text("당신의 애칭을 알려주세요")
                .font(.pretendard(size: 20, weight: .bold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            Text("애칭이 없다면 이름 또는 별명을 알려주셔도 좋아요")
                .font(.pretendard(size: 16, weight: .regular))
                .foregroundColor(Color(R.color.gray156))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
                .padding(.leading, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}

struct OnboardingNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingNicknameView()
    }
}
