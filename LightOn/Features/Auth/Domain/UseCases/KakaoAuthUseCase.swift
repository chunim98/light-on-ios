//
//  KakaoAuthUseCase.swift
//  LightOn
//
//  Created by 신정욱 on 5/2/25.
//

import Combine

final class KakaoAuthUseCase {
    
    private let repository: KakaoAuthResultRepository
    
    init(repository: KakaoAuthResultRepository) {
        self.repository = repository
    }
    
    func signIn() -> AnyPublisher<KakaoAuthResult, Error> {
        repository.fetchAuthResult()
    }
}
