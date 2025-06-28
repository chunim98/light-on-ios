//
//  DuplicationStateRepository.swift
//  LightOn
//
//  Created by 신정욱 on 6/3/25.
//

import Combine

import Alamofire

protocol DuplicationStateRepository {
    /// 이메일 중복 조회
    func getDuplicationState(
        emailText: String
    ) -> AnyPublisher<DuplicationState, Never>
}
