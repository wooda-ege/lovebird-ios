//
//  AuthorizationValidator.swift
//  LoveBird
//
//  Created by 이예은 on 3/18/24.
//

import Foundation
import ComposableArchitecture

//final class AuthorizationValidator {
//    // API N개가 동시에 발송되는 상황에서 토큰이 만료된 경우. Reissue의 동시성 문제를 방어하기 위함
//    static let shared = AuthorizationValidator()
//
//    private let group = DispatchGroup()
//    private let serialQueue = DispatchQueue(label: "com.lovebird.reissue.serialQueue")
//
//    @Dependency(\.userData) var userData
//
//    private init() { }
//
//    func validate(_ completion: @escaping (Result<String, Error>) -> Void) {
//        serialQueue.async { [weak self] in
//            guard let self = self else { return }
//            self.group.enter()
//
//            self._validate { [weak self] (result) in
//                guard let self = self else { return }
//                completion(result)
//                self.group.leave()
//            }
//
//            self.group.wait()
//        }
//    }
//
//    private func _validate(_ completion: @escaping (Result<String, Error>) -> Void) {
//        guard accessToken.isExpired else {
//            completion(.success(accessToken.token))
//            return
//        }
//        guard refreshToken.isExpired == false else {
//            completion(
//                .failure(
//                    QMAPIError.init(
//                        code: .refreshTokenExpired,
//                        errorDescription: "로그인 세션이 만료되어 로그아웃되었어요.\n다시 로그인해 주세요.(timeout)"
//                    )
//                )
//            )
//            return
//        }
//
//        let urlString = QMAPIServer.current.apiBaseV2 + "/auth/qmarket/reissue"
//        let url = URL(string: urlString)!
//        let urlRequest = try! URLRequest(url: url, method: .post, headers: ["RefreshToken": refreshToken.token])
//
//        let timeout = 5.0
//
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = timeout
//        sessionConfig.timeoutIntervalForResource = timeout
//        let session = URLSession(configuration: sessionConfig)
//
//        let task = session.dataTask(with: urlRequest) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else if let data = data {
//                do {
//                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
//                        completion(.failure(QMAPIError(code: .reissueFailed)))
//                        return
//                    }
//
//                    // 2023-11-09 계정통합 배포관련 문제로 인해 기존 코드에 추가됩니다. reissue API 한정으로 http status code 4xx의 경우 무조건 로그아웃 로직을 태웁니다.
//                    if let httpResponse = response as? HTTPURLResponse,
//                       (400...499).contains(httpResponse.statusCode) {
//                        var reissueFailedMessage = "로그인 세션이 만료되어 로그아웃되었어요.\n다시 로그인해 주세요."
//
//                        if let code = json["code"] as? String {
//                            reissueFailedMessage += "(\(code))"
//                        }
//
//                        completion(
//                            .failure(
//                                QMAPIError(
//                                    code: .reissueFailed,
//                                    errorDescription: reissueFailedMessage
//                                )
//                            )
//                        )
//                        return
//                    }
//
//                    // 2023-11-09 레거시 코드입니다.
//                    if let code = json["code"] as? String,
//                       code == "ERR0001" || code == "ERR0003" || code == "ERR1003" || code == "ERR1004" || code == "ERR1005" || code == "ERR1006" || code == "ERR1007" {
//                        completion(.failure(QMAPIError(code: .reissueFailed)))
//                        return
//                    }
//
//                    let responseModel = try JSONDecoder().decode(ReissueResponse.self, from: data)
//                    let authResult: AuthResult = .init(
//                        isWithdrawal: false,
//                        accessToken: .init(token: responseModel.data.accessToken.token, expired: responseModel.data.accessToken.expired),
//                        refreshToken: .init(token: responseModel.data.refreshToken.token, expired: responseModel.data.refreshToken.expired),
//                        isNewUser: false
//                    )
//
//                    _KeyChain.shared.accessToken = authResult.accessToken
//                    _KeyChain.shared.refreshToken = authResult.refreshToken
//                    completion(.success(authResult.accessToken.token))
//                } catch {
//                    completion(.failure(error))
//                }
//            } else {
//                completion(.failure(QMAPIError(code: .reissueFailed)))
//            }
//        }
//
//        task.resume()
//    }
//}
//
//private struct ReissueResponse: Decodable {
//    let message: String
//    let data: DataClass
//
//    struct DataClass: Decodable {
//        let accessToken: Token
//        let refreshToken: Token
//
//        struct Token: Decodable {
//            let token: String
//            let expired: String
//        }
//    }
//}
//// swiftlint:enable force_try
