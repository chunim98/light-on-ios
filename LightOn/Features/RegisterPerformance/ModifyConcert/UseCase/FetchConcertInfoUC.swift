//
//  FetchConcertInfoUC.swift
//  LightOn
//
//  Created by 신정욱 on 9/7/25.
//

import Combine

final class FetchConcertInfoUC {
    
    private let repo: ModifyConcertRepo
    
    init(repo: ModifyConcertRepo) {
        self.repo = repo
    }
    
    /// 공연 상세정보 조회
    /// - 결제 정보가 누락된 콘서트 정보와 결제 정보를 취합
    func execute(id: Int) -> AnyPublisher<RegisterConcertInfo, Never> {
        Publishers.Zip(
            repo.fetchConcertInfo(id: id),
            repo.fetchPaymentInfo(id: id)
        )
        .map { preConcertInfo, paymentInfo in
            var preConcertInfo = preConcertInfo
            
            preConcertInfo.accountHolder = paymentInfo.accountHolder
            preConcertInfo.account = paymentInfo.accountNumber
            preConcertInfo.bank = paymentInfo.bank
            
            return preConcertInfo
        }
        .share()
        .eraseToAnyPublisher()
    }
}
