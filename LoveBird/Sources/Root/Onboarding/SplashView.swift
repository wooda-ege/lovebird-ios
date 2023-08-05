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
        VStack {
          ZStack(alignment: .center) {
            Image(R.image.img_backHeart)
              .resizable()
              .scaledToFit()
            
            HStack(alignment: .center) {
              Spacer()
              Text("러브")
                .foregroundColor(Color(R.color.green100))
              Text("버드")
                .foregroundColor(Color(R.color.secondary))
              Spacer()
            }
            .font(.custom(R.font.gmarketSansBold, size: 38))
          }
        }
      } else {
//        LoginView()
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
