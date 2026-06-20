//
//  NetworkService.swift
//  PayPhoneTest
//
//  Created by Nelson Cruz Mora on 20/6/26.
//  Copyright © 2026 Nelson Cruz Mora. All rights reserved.
//

import Alamofire
import Foundation

enum NetworkError: LocalizedError {
    case invalidResponse
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server."
        case .emptyResponse:
            return "The server returned an empty response."
        }
    }
}

final class NetworkService {
    static let shared = NetworkService()

    private let session: Session

    init(session: Session = .default) {
        self.session = session
    }

    func fetchUsers() async throws -> [UserDTO] {
        let url = "https://jsonplaceholder.typicode.com/users"
        return try await withCheckedThrowingContinuation { continuation in
            session
                .request(url, method: .get)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let users = try JSONDecoder().decode([UserDTO].self, from: data)
                            guard !users.isEmpty else {
                                print(":: Error empty response")
                                continuation.resume(throwing: NetworkError.emptyResponse)
                                return
                            }

                            print(":: Success: \(users.count) users")
                            users.forEach {
                                print("\($0)") // User List
                            }
                            continuation.resume(returning: users)
                        } catch {
                            print(":: Error decoding response: \(error.localizedDescription)")
                            continuation.resume(throwing: error)
                        }

                    case .failure(let error):
                        print(":: Error: \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
