//
//  CountDownUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import Foundation
import Combine

final class CountDownUC {
    
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Methods
    
    /// 트리거 될 때마다 타이머 생성
    func startCountDown(
        trigger: AnyPublisher<Void, Never>,
        stopTrigger1: AnyPublisher<Void, Never>,
        stopTrigger2: AnyPublisher<String, Never>
    ) -> AnyPublisher<Int, Never> {
        /// 정지 트리거 서브젝트
        let stopTriggerSubject = PassthroughSubject<Void, Never>()
        
        // 인증 완료 시, 타이머 정지
        stopTrigger1
            .sink { _ in stopTriggerSubject.send(()) }
            .store(in: &cancellables)
        
        // 휴대폰 번호 수정 시, 타이머 정지
        stopTrigger2
            .drop(untilOutputFrom: trigger)
            .sink { _ in stopTriggerSubject.send(()) }
            .store(in: &cancellables)
        
        return trigger.map {
            // 타이머 구독 시작되는 순간 카운트다운 시작
            Timer.publish(every: 1, on: .main, in: .default).autoconnect()
                .scan(300) { acc, _ in acc - 1 }                 // 299 부터 방출
                .prepend(300)                                    // 초기값 300초 즉시 방출
                .prefix { $0 >= 0 }                             // 0초 되면 구독 종료
                .prefix(untilOutputFrom: stopTriggerSubject)    // 정지 트리거, 즉시 구독 종료
        }
        .switchToLatest()   // 새 트리거 오면 이전 타이머 자동 취소
        .eraseToAnyPublisher()
    }
}
