//
//  CommonBottomSheetButtonView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/07/02.
//

import ComposableArchitecture
import SwiftUI

struct CommonBottomSheetButtonView: View {
  
  let initialAction: () -> Void
  let confirmAction: () -> Void

  var body: some View {
    HStack(spacing: 8) {
      Button(action: self.initialAction) {
        Text(R.string.localizable.onboarding_date_initial)
          .font(.pretendard(size: 16, weight: .semiBold))
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(Color(R.color.gray05))
          .cornerRadius(12)
      }
      
      Button(action: self.confirmAction) {
        Text(R.string.localizable.common_next)
          .font(.pretendard(size: 16, weight: .semiBold))
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(.black)
          .cornerRadius(12)
      }
    }
    .foregroundColor(.white)
  }
}

struct SkipBirthButtonView: View {
  
  let skipAction: () -> Void
  let confirmAction: () -> Void

  var body: some View {
    HStack(spacing: 8) {
      Button(action: self.skipAction) {
        Text(R.string.localizable.onboarding_skip)
          .font(.pretendard(size: 16, weight: .semiBold))
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(Color(R.color.gray05))
          .cornerRadius(12)
      }
      
      Button(action: self.confirmAction) {
        Text(R.string.localizable.common_confirm)
          .font(.pretendard(size: 16, weight: .semiBold))
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(.black)
          .cornerRadius(12)
      }
    }
    .foregroundColor(.white)
  }
}

struct SkipBirthButtonView_Previews: PreviewProvider {
  static var previews: some View {
    SkipBirthButtonView {
      
    } confirmAction: {
       
    }
  }
}
