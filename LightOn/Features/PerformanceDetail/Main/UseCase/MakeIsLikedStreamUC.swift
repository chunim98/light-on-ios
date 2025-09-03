//
//  MakeIsLikedStreamUC.swift
//  LightOn
//
//  Created by 신정욱 on 9/3/25.
//

import Combine

/// 찜(좋아요) 상태를 조회하고 업데이트하는 스트림을 생성
final class MakeIsLikedStreamUC {
    
    private let repo: IsLikedRepo
    
    init(repo: IsLikedRepo) {
        self.repo = repo
    }
    
    // MARK: Methods
    
    /// 찜(좋아요) 상태를 조회하고 업데이트하는 스트림을 생성
    /// - Returns: 찜(좋아요) 상태(Bool타입) 반환
    func execute(
        id: Int,
        mode: AnyPublisher<LikeButtonMode, Never>,
        trigger: AnyPublisher<Void, Never>
    ) -> AnyPublisher<Bool, Never> {
        /// 1) 찜(좋아요) 초기 상태 조회
        /// - 로그인 상태가 아니면 방출하지 않음
        /// - 모드별로 다른 동작을 처리
        ///   - login: 아무 이벤트 방출 안함
        ///   - toggle: 좋아요 상태 조회
        let initial = mode
            .first() // 최초 모드 한 번만 사용
            .compactMap { [weak self] mode -> AnyPublisher<Bool, Never>? in
                switch mode {
                case .login: Empty().eraseToAnyPublisher()
                case .toggle: self?.repo.fetch(id: id)
                }
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
        
        /// 2) 이후에는 trigger마다 최신 모드로 조회
        /// - 모드별로 다른 동작을 처리
        ///   - login: 로그인 화면으로 라우팅만 하고 이벤트 방출 안함
        ///   - toggle: 좋아요 상태 토글 요청
        let subsequent = trigger
            .withLatestFrom(mode)
            .compactMap { [weak self] mode -> AnyPublisher<Bool, Never>? in
                switch mode {
                case .login:
                    AppCoordinatorBus.shared.navigate(to: .login)
                    return Empty().eraseToAnyPublisher()
                    
                case .toggle:
                    return self?.repo.requestToggle(id: id)
                }
            }
            .switchToLatest()
            .share()
            .eraseToAnyPublisher()
        
        // 초기 → 이후 순서대로 이어 붙이기
        return initial
            .append(subsequent)
            .eraseToAnyPublisher()
    }
}
