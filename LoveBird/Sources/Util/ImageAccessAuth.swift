//
//  ImageAccessAuth.swift
//  LoveBird
//
//  Created by 이예은 on 2023/08/19.
//

import Foundation
import AVFoundation
import Photos

struct ImageAccessAuth {
  static func checkCameraPermission(completion: @escaping (Bool) -> Void) {
    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
      if granted {
        print("Camera: 권한 허용")
      } else {
        print("Camera: 권한 거부")
      }
      
      completion(granted)
    })
  }

  static func checkAlbumPermission(completion: @escaping (String) -> Void) {
    PHPhotoLibrary.requestAuthorization( { status in
      switch status {
      case .authorized:
        completion("허용")
      case .denied:
        completion("거부")
      case .restricted, .notDetermined:
        completion("미선택")
      default:
        break
      }
    })
  }
}
