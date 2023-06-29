//
//  SplashView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/29.
//

import SwiftUI

struct SplashView: View {
  @State var isActive: Bool = true
  
  var body: some View {
    ZStack {
      if self.isActive {
        ZStack(alignment: .center) {
          Image(R.image.img_backHeart)
            .resizable()
            .scaledToFit()
          Image(R.image.img_frontHeart)
            .resizable()
            .scaledToFit()
            .foregroundColor(Color(R.color.secondary))
          Image(R.image.img_lovebird)
            .resizable()
            .frame(width: 136, height: 38)
        }
      } else {
        
      }
    }
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        withAnimation {
          self.isActive = false
        }
      }
    }
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
  }
}
