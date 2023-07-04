//
//  BottomSheetView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {

  @State private var height: CGFloat = 0
  @Binding var isOpen: Bool
  let content: Content
  let offsetY = UIScreen.height - (UIApplication.edgeInsets.top + UIApplication.edgeInsets.bottom)
  
  init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
    self.content = content()
    self._isOpen = isOpen
  }
  
  @GestureState private var translation: CGFloat = 0
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        self.indicator
          .padding(.vertical, 10)

        self.content
          .padding(.vertical, 20)
      }
      .modifier(GetHeightModifier(height: $height))
      .padding(.horizontal, 16)
      .padding(.bottom, geometry.safeAreaInsets.bottom)
      .frame(width: geometry.size.width, alignment: .top)
      .background(.white)
      .cornerRadius(32)
      .shadow(color: .black.opacity(0.08), radius: 32)
      .offset(y: self.isOpen ? self.offsetY + self.translation - self.height : UIScreen.height)
      .animation(.interactiveSpring(), value: self.isOpen)
      .gesture(
        DragGesture().updating(self.$translation) { value, state, _ in
          if value.translation.height < 0 { return }
          state = value.translation.height
        }.onEnded { value in
          guard value.translation.height > min(self.height * 0.5, 200) else { return }
          self.isOpen = false
        }
      )
    }
  }

  private var indicator: some View {
    RoundedRectangle(cornerRadius: 2)
      .fill(Color(R.color.gray07))
      .frame(
        width: 48,
        height: 4
      )
  }
}
