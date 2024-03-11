//
//  KFImageProtocol+Extneion.swift
//  LoveBird
//
//  Created by 황득연 on 3/2/24.
//

import Kingfisher

extension KFImageProtocol {
  init(urlString: String?) {
    guard let urlString else {
      self.init(nil)
      return
    }
    let url = URL(string: urlString)
    self.init(url)
  }
}
