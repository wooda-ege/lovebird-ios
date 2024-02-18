//
//  AWSS3Uploader.swift
//  LoveBird
//
//  Created by 황득연 on 2/18/24.
//

import Foundation

final class AWSS3Uploader {
  static func upload(_ data: Data, toPresignedURLString remoteURLString: String) async throws -> String? {
    guard let url = URL(string: remoteURLString) else { throw URLError(.badURL) }

    var request = URLRequest(url: url)
    request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
    request.cachePolicy = .reloadIgnoringLocalCacheData
    request.httpMethod = "PUT"

    do {
      let (_, response) = try await URLSession.shared.upload(for: request, from: data)
      guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
        throw URLError(.badServerResponse)
      }
      return remoteURLString
    } catch {
      // 에러 처리
      throw error
    }
  }
}
