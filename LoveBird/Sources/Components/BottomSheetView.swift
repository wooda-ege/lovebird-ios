//
//  BottomSheetView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/21.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    init(isOpen: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.minHeight = 200
        self.maxHeight = 400
        self.content = content()
        self._isOpen = isOpen
    }
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color(R.color.gray156))
            .frame(
                width: 48,
                height: 4
        )
    }

    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .padding(geometry.safeAreaInsets)
            .frame(width: geometry.size.width, alignment: .top)
            .background(.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 16)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.isOpen ? 0 + translation : geometry.size.height / 3, translation))
            .animation(.interactiveSpring(), value: isOpen)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    if value.translation.height < 0 {
                        return
                    }
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * 0.5
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}
