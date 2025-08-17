//
//  GetPerformancesUC.swift
//  LightOn
//
//  Created by 신정욱 on 7/15/25.
//

import Combine

final class GetPerformancesUC {
    
    private let repo: PerformanceRepo
    
    init(repo: PerformanceRepo) {
        self.repo = repo
    }
    
    /// 최신 or 추천 공연 조회
    ///
    /// 데이터 로드 트리거 (로그인 상태 + viewDidAppear)
    func getRecentRecommendeds(
        loginState: AnyPublisher<SessionManager.LoginState, Never>
    ) -> AnyPublisher<[SmallPerformanceCellItem], Never> {
        loginState.compactMap {
            [weak self] state -> AnyPublisher<[SmallPerformanceCellItem], Never>? in
            guard let self else { return nil }
            
            if state == .login {
                // 추천 공연
                // - 로그인일 때 요청됨
                // - 만약 추천공연이 빈 배열이면, 최신공연으로 폴백
                return repo.requestRecommended()
                    .map {
                        $0.isEmpty
                        ? self.repo.requestRecent()
                        : Just($0).eraseToAnyPublisher()
                    }
                    .switchToLatest()
                    .eraseToAnyPublisher()
                
            } else {
                // 최신공연
                // - 로그아웃일 때 요청됨
                return repo.requestRecent()
            }
            
        }
        .switchToLatest()
        .share()
        .eraseToAnyPublisher()
    }
    
    /// 주목받은 아티스트 공연 조회
    func getSpotlighted(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[MediumPerformanceCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestSpotlighted() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
    
    /// 인기공연 조회
    func getPopulars(
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<[LargePerformanceCellItem], Never> {
        trigger
            .compactMap { [weak self] in self?.repo.requestPopular() }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
    }
}
