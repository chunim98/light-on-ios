//
//  KakaoAuthResultRepository.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import Combine

protocol KakaoAuthResultRepository {
    func fetchAuthResult() -> AnyPublisher<KakaoAuthResult, Error>
}
