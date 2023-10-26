//
//  ChuckNorisServiceImplementation.swift
//  ReloadableExample
//
//  Created by Gleb Kovalenko on 27.07.2023.
//

import Foundation
import HTTPTransport
import SDAO
import ServiceCore
import Codex
import Models
import TCA
import Monreau

// MARK: - ChuckNorisServiceImplementation

public final class ChuckNorisServiceImplementation: WebService {
    
    // MARK: - Properties
    
    /// `ChuckNoris` dao instance
    @Dependency(\.chuckNorisDAO) var chuckNorisDAO
    
    // MARK: - Initializer
    
    public init() {
        super.init(
            baseURL: URL(string: "https://api.chucknorris.io").unsafelyUnwrapped,
            transport: HTTPTransport()
        )
    }
}

// MARK: - CatService

extension ChuckNorisServiceImplementation: ChuckNorisService {
    
    public func obtainRandomJoke() -> ServiceCall<ChuckNorisPlainObject> {
        createCall {
            let request = HTTPRequest(
                httpMethod: .get,
                endpoint: "/jokes/random",
                base: self.baseRequest
            )
            let result = self.transport.send(request: request)
            switch result {
            case .success(let response):
                do {
                    let data = response.body.unsafelyUnwrapped
                    let result = try data.decoded() as ChuckNorisPlainObject
                    try self.chuckNorisDAO.erase()
                    try self.chuckNorisDAO.persist(result)
                    return .success(result)
                } catch {
                    return .failure(error)
                }
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    public func readRandomJoke() -> ServiceCall<ChuckNorisPlainObject?> {
        createCall {
            let randomJoke = try self.chuckNorisDAO.read().first
            return .success(randomJoke)
        }
    }
}
