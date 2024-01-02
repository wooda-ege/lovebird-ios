//
//  LoginTypeView.swift
//  LoveBird
//
//  Created by 황득연 on 12/31/23.
//

import SwiftUI

struct LoginTypeView: View {
  enum `Type` {
    case kakao
    case apple

    var logoImage: LoveBirdImages {
      switch self {
      case .kakao:
        LoveBirdAsset.imgKakaotalk
      case .apple:
        LoveBirdAsset.imgApple
      }
    }

    var title: String {
      switch self {
      case .kakao:
        "카카오로 계속하기"
      case .apple:
        "Apple로 계속하기"
      }
    }

    var titleColor: LoveBirdColors {
      switch self {
      case .kakao:
        LoveBirdAsset.gray12
      case .apple:
        LoveBirdAsset.gray01
      }
    }

    var backgroundColor: LoveBirdColors {
      switch self {
      case .kakao:
        LoveBirdAsset.kakao
      case .apple:
        LoveBirdAsset.gray12
      }
    }
  }

  let type: `Type`

  init(type: `Type`) {
    self.type = type
  }

  var body: some View {
    HStack(alignment: .center) {
      Image(asset: type.logoImage)
        .padding(.leading, 16)
        .frame(maxWidth: .infinity, alignment: .leading)

      Text(type.title)
        .font(.pretendard(size: 16))
        .foregroundColor(Color(asset: type.titleColor))

      Rectangle()
        .fill(Color(.clear))
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 60)
    .background(Color(asset: type.backgroundColor))
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }
}
