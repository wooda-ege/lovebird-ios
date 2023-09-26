//
//  OnboardingDateView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/09/14.
//

import SwiftUI

struct OnboardingDateView: View {

  let date: SimpleDate
  let onTap: () -> Void

  var body: some View {
    TouchableStack {
      HStack(alignment: .center, spacing: 8) {
        Spacer()

        Text(String(self.date.year))

        Text("/")
          .foregroundColor(Color(asset: LoveBirdAsset.gray05))

        Text(String(self.date.month))

        Text("/")
          .foregroundColor(Color(asset: LoveBirdAsset.gray05))

        Text(String(self.date.day))

        Spacer()
      }
    }
    .frame(maxWidth: .infinity)
    .font(.pretendard(size: 18))
    .foregroundColor(.black)
    .frame(height: 56)
    .roundedBackground(cornerRadius: 12, color: Color(asset: LoveBirdAsset.primary))
    .onTapGesture { self.onTap() }
  }
}


