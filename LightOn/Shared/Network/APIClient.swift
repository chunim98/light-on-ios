//
//  APIClient.swift
//  LightOn
//
//  Created by 신정욱 on 6/5/25.
//

import Foundation

import Alamofire

final class APIClient {
    static let withAuth = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        let interceptor = AuthenticationInterceptor(
            authenticator: TokenAuthenticator(),
            credential: TokenCredential()
        )
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [APILogger()]
        )
    }()
    
    static let plain = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return Session(
            configuration: configuration,
            eventMonitors: [APILogger()]
        )
    }()
}
