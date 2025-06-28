//
//  CountDownUC.swift
//  LightOn
//
//  Created by 신정욱 on 6/29/25.
//

import Foundation
import Combine

final class CountDownUC {
    /// 트리거 될 때마다 타이머 생성
    func startCountDown(
        trigger1: AnyPublisher<Void, Never>,
        trigger2: AnyPublisher<Void, Never>
    ) -> AnyPublisher<Int, Never> {
        Publishers.Merge(trigger1, trigger2)
            .map {
                // 타이머 구독 시작되는 순간 카운트다운 시작
                Timer.publish(every: 1, on: .main, in: .default).autoconnect()
                    .scan(10) { acc, _ in acc - 1 }
                    .prefix { $0 >= 0 } // 0초 되면 구독 종료
            }
            .switchToLatest()   // 새 트리거 오면 이전 타이머 자동 취소
            .eraseToAnyPublisher()
    }
}
