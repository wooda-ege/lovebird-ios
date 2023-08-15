//
//  SplashView.swift
//  LoveBird
//
//  Created by 이예은 on 2023/06/29.
//

import SwiftUI
import UIKit
import ComposableArchitecture

struct SplashView: View {
  @State var isActive: Bool = true
  let background = Color.pink
  
  var body: some View {
    ZStack {
      if self.isActive {
        VStack {
          ZStack(alignment: .center) {
            Image(R.image.img_splashView)
              .resizable()
              .scaledToFill()
//            rgba(255, 0, 122, 1), rgba(255, 106, 115, 1)
          }
        }
      } else {
        LoginView(store: Store(initialState: LoginCore.State(), reducer: LoginCore()))
      }
    }
    .ignoresSafeArea()
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
