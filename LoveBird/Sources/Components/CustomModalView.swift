//
//  CustomModalView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/14.
//

import SwiftUI

struct CustomModalView: View {
    @Binding var image: UIImage?
    @Binding var isCustomModalPresented: Bool

    var body: some View {
        VStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFit()
            }

            Button("Select Image") {
                isCustomModalPresented = true
            }
        }
    }
}




