//
//  DuplicationStateRepository.swift
//  LightOn
//
//  Created by 신정욱 on 6/3/25.
//

import Combine

import Alamofire

protocol DuplicationStateRepository {
    func fetchDuplicationState(
        emailText: String
    ) -> AnyPublisher<DuplicationState, Never>
}
