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
          .foregroundColor(Color(R.color.gray05))

        Text(String(self.date.month))

        Text("/")
          .foregroundColor(Color(R.color.gray05))

        Text(String(self.date.day))

        Spacer()
      }
    }
    .font(.pretendard(size: 18))
    .foregroundColor(.black)
    .frame(height: 56)
    .roundedBackground(cornerRadius: 12, color: Color(R.color.primary))
    .onTapGesture { self.onTap() }
  }
}


