//
//  AWSS3Uploader.swift
//  LoveBird
//
//  Created by 황득연 on 2/18/24.
//

import Foundation

final class AWSS3Uploader {
  static func upload(_ data: Data, toPresignedURLString remoteURLString: String, fileName: String) async throws -> String? {
    guard let url = URL(string: remoteURLString) else { throw URLError(.badURL) }

    var request = URLRequest(url: url)
    request.setValue("\(fileName)/png", forHTTPHeaderField: "Content-Type")
    request.cachePolicy = .reloadIgnoringLocalCacheData
    request.httpMethod = "PUT"
    request.timeoutInterval = 10

    do {
      let (_, response) = try await URLSession.shared.upload(for: request, from: data)
      guard let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
        throw URLError(.badServerResponse)
      }
      print("<----- Network Success (AWSUpload)\n")
      print("\(response)")
      return remoteURLString
    } catch {
      print("<----- Network Failure (AWSUpload)\n")
      print("Error: \(error)")
      throw error
    }
  }
}
