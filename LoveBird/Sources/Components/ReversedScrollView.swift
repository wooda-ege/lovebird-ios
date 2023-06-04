//
//  ReversedScrollView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/05/25.
//

import SwiftUI

struct ReversedScrollView<Content: View>: View {
    var content: Content
    let onOffsetChanged: (CGPoint) -> Void

    init(onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
         @ViewBuilder content: () -> Content) {
        self.onOffsetChanged = onOffsetChanged
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: OffsetPreferenceKey.self,
                            value: proxy.frame(
                                in: .global
                            ).origin
                        )
                    }
                    Spacer()
                    self.content
                }
                .frame(minHeight: proxy.size.height)
            }
            .onPreferenceChange(OffsetPreferenceKey.self,
                                perform: onOffsetChanged)
        }
    }
}


struct OffsettableScrollView<Content: View>: View {

    let axes: Axis.Set
    let showsIndicator: Bool
    let onOffsetChanged: (CGPoint) -> Void
    let content: Content
    
    init(axes: Axis.Set = .vertical,
         showsIndicator: Bool = true,
         onOffsetChanged: @escaping (CGPoint) -> Void = { _ in },
         @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicator = showsIndicator
        self.onOffsetChanged = onOffsetChanged
        self.content = content()
    }
    
    var body: some View {
            ScrollView(axes, showsIndicators: showsIndicator) {
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: OffsetPreferenceKey.self,
                        value: proxy.frame(
                            in: .named("ScrollViewOrigin")
                        ).origin
                    )
                }
                .frame(width: 0, height: 0)
                content
            }
            .coordinateSpace(name: "ScrollViewOrigin")
            .onPreferenceChange(OffsetPreferenceKey.self,
                                perform: onOffsetChanged)
        }

}

private struct OffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) { }
}
