//
//  HomeLeftLineView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/26.
//

import SwiftUI

struct HomeLeftLineView: View {
  
  let timeState: Diary.TimeState
  
  var body: some View {
    switch timeState {
    case .previous:
      ZStack(alignment: .top) {
        Rectangle()
          .fill(Color(R.color.primary))
          .frame(maxWidth: 2, maxHeight: .infinity)
        Circle()
          .fill(Color(R.color.primary))
          .frame(width: 8, height: 8)
          .padding(.top, 41)
      }
      .padding(.leading, 2)
    case .current:
      ZStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 0) {
          Rectangle()
            .fill(Color(R.color.primary))
            .frame(width: 2, height: 40)
          Spacer()
        }.frame(width: 2)
        ZStack {
          Circle()
            .stroke(Color(R.color.primary), lineWidth: 1.2)
            .frame(width: 12, height: 12)
          Circle()
            .fill(Color(R.color.primary))
            .frame(width: 6, height: 6)
        }
        .background(Color.white)
        .padding(.top, 39)
      }
    case .following:
      VStack {
        Circle()
          .stroke(Color(R.color.primary), lineWidth: 1)
          .frame(width: 8, height: 8)
          .background(Color.white)
          .padding(.top, 41)
        Spacer()
      }
      .padding(.leading, 2)
    }
  }
}

struct HomeLeftLineView_Previews: PreviewProvider {
  static var previews: some View {
    HomeLeftLineView(timeState: .current)
  }
}
