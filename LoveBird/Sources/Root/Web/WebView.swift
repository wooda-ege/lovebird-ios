//
//  WebView.swift
//  LoveBird
//
//  Created by 황득연 on 2023/08/13.
//

import SwiftUI
import WebKit

struct MyWebView: UIViewRepresentable {

  var urlToLoad: String

  func makeUIView(context: Context) -> WKWebView {
    guard let url = URL(string: self.urlToLoad) else {
      return WKWebView()
    }
    let webView = WKWebView()

    webView.load(URLRequest(url: url))
    return webView
  }

  //업데이트 ui view
  func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<MyWebView>) {

  }
}

struct MyWebView_Previews: PreviewProvider {
  static var previews: some View {
    MyWebView(urlToLoad: "https://www.naver.com")
  }
}
