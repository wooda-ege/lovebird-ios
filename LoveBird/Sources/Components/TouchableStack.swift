//
//  TouchableStack.swift
//  LoveBird
//
//  Created by 황득연 on 2023/06/04.
//

import SwiftUI

struct TouchableStack<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            self.content

            Rectangle()
                .fill(Color.clear)
        }
    }
}

//struct TouchableStack_Previews: PreviewProvider {
//    static var previews: some View {
//        TouchableStack()
//    }
//}
