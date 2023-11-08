//
//  ImageAccessAuth.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/19.
//

import UIKit
import Foundation
import AVFoundation
import Photos

struct ImageAccessAuth {
  static func checkAlbumPermission(completion: @escaping (AlbumPermission) -> Void) {
    PHPhotoLibrary.requestAuthorization( { status in
      switch status {
      case .authorized:
        completion(.authorized)
      case .denied:
        completion(.denied)
      case .restricted, .notDetermined:
        completion(.restricted)
      default:
        break
      }
    })
  }
}

enum AlbumPermission {
  case authorized
  case denied
  case restricted
}
