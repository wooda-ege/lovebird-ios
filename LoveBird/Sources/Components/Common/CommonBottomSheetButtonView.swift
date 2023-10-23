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
        Text(LoveBirdStrings.onboardingDateInitial)
          .font(.pretendard(size: 16, weight: .semiBold))
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(Color(asset: LoveBirdAsset.gray05))
          .cornerRadius(12)
      }
      
      Button(action: self.confirmAction) {
        Text(LoveBirdStrings.commonNext)
          .font(.pretendard(size: 16, weight: .semiBold))
          .frame(maxWidth: .infinity, maxHeight: 56)
          .background(.black)
          .cornerRadius(12)
      }
    }
    .foregroundColor(.white)
  }
}
